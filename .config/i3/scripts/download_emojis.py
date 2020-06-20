#!/usr/bin/env python3
import re
import subprocess
try: 
    from BeautifulSoup import BeautifulSoup as bs
except ImportError:
    from bs4 import BeautifulSoup as bs


class EmojipediaFetcher:
    def __init__(self, final_csv_file = '/tmp/all_emojis.csv'):
        self.html_files = []
        self.sep = ':'
        self.final_csv_file = final_csv_file 
        # final file that stores all emojis
        open(self.final_csv_file, 'w').close()
        self._emojis, self._descrs = [], []


    def register(self, html, dst = '/tmp/emojis.html'):
        assert 'http' in html,\
            "Provide an emoji sheet such as https://emojipedia.org/people/"
        subprocess.check_output(['wget', html, '-O', dst])
        self.html_files.append(dst)


    def generate_emoji_csv_file(self, sep = ':'):
        self.sep = sep 
        for html in self.html_files:
            with open(html) as f:
                parsed_html = bs(f, features = 'lxml')
                emoji_tags = parsed_html.body.\
                    find('ul', {'class': 'emoji-list'}).\
                    find_all('li')
            for tag in emoji_tags:
                self._emojis.append(tag.find('span').text)
                self._descrs.append(" ".join(re.findall('[^ ]+[A-Za-z0-9]+', tag.find('a').text.lower())))
        with open(self.final_csv_file, 'a') as f:
            for emo, descr in zip(self._emojis, self._descrs):
                f.write("%s%s\t%s\n" %(emo, self.sep, descr))

#subprocess.check_output(['wget', 'https://emojipedia.org/people/', '-O', '/tmp/people.html'])
'''
subprocess.check_output(['wget', 'https://emojipedia.org/nature/', '-O', '/tmp/nature.html'])
subprocess.check_output(['wget', 'https://emojipedia.org/food-drink/', '-O', '/tmp/food-drink.html'])
subprocess.check_output(['wget', 'https://emojipedia.org/activity/', '-O', '/tmp/activity.html'])
subprocess.check_output(['wget', 'https://emojipedia.org/travel-places/', '-O', '/tmp/travel-places.html'])
subprocess.check_output(['wget', 'https://emojipedia.org/objects/', '-O', '/tmp/objects.html'])
subprocess.check_output(['wget', 'https://emojipedia.org/symbols/', '-O', '/tmp/symbols.html'])
subprocess.check_output(['wget', 'https://emojipedia.org/flags/', '-O', '/tmp/flags.html'])
'''
