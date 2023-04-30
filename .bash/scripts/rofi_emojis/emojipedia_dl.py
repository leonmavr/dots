#!/usr/bin/env python3
import re
import subprocess
import os
from typing import List, Union
try: 
    from BeautifulSoup import BeautifulSoup as bs
except ImportError:
    from bs4 import BeautifulSoup as bs


def download_as_html(offline_mode = True) -> Union[List[str], None]:
    if offline_mode:
        # nothing to do - emojis already downloaded
        return None
    ret = []
    emoji_links = ['https://emojipedia.org/people',
                   'https://emojipedia.org/nature',
                   'https://emojipedia.org/food-drink',
                   'https://emojipedia.org/activity',
                   'https://emojipedia.org/travel-places',
                   'https://emojipedia.org/objects',
                   'https://emojipedia.org/symbols',
                   'https://emojipedia.org/flags'] 
    for link in emoji_links:
        html_file = os.path.join('/tmp', link.split('/')[-1] + '.html')
        ret.append(html_file)
        if not os.path.isfile(html_file):
            try:
                subprocess.run(['curl', link, '-o', html_file])
            except:
                subprocess.run(['wget', link, '-O', html_file])
    return ret


def html_to_csv(html_files: Union[List[str], None], offline_mode = True) -> str:
    """html_to_csv.

    Parameters
    ----------
    html_files : Union[List[str], None]
        emojipedia html links to scrap emojis from 
    offline_mode :
        work with a csv file that contains <emoji>:<description> instead of
        emojipedia

    Returns
    -------
    the final csv file that contains all emojis

    """
    ### try offline mode
    if html_files is None or offline_mode:
        # search for cached csv file at ~/.config/rofi_emoji_menu/all_emojis.csv
        # if search fails, fallback to online mode
        saved_csv = os.path.join(os.environ['HOME'], '.config', 'rofi_emoji_menu', 'all_emojis.csv')
        if os.path.isfile(saved_csv):
            return saved_csv 
    ### fallback to online
    final_csv_file = os.path.join('/tmp', 'rofi_emojis.csv')
    ret = final_csv_file
    emojis = []
    descriptions = []
    for html in html_files:
        with open(html) as f:
            parsed_html = bs(f, features = 'lxml')
            emoji_tags = parsed_html.body.\
                find('ul', {'class': 'emoji-list'}).\
                find_all('li')
        for tag in emoji_tags:
            try:
                emojis.append(tag.find('span').text)
                descriptions.append(" ".join(re.findall('[^ ]+[A-Za-z0-9]+', tag.find('a').text.lower())))
            except:
                pass
    with open(final_csv_file, 'a') as f:
        f.write("( ͡° ͜ʖ ͡°)  : lenny faces...\n")
        f.write("<(￣︶￣)>: kawaii faces...\n")
        for emo, descr in zip(emojis, descriptions):
            f.write("%s%s\t%s\n" % (emo, ':', descr))
            # add an option which opens another popup for additional
    return ret 


html_emoji_files = download_as_html()
print(html_to_csv(html_emoji_files))
