#!/usr/bin/env python3
import re
import subprocess
import os
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
        subprocess.run(['wget', html, '-O', dst])
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
            # add an option which opens another popup for lenny faces
            f.write("( ͡° ͜ʖ ͡°): lenny faces...\n")
                

