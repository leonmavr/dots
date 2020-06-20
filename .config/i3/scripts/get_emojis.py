#!/usr/bin/env python3
from download_emojis import EmojipediaFetcher
import sys

final_csv_file = '/tmp/all_emojis.csv' if len(sys.argv) == 1\
        else sys.argv[1]

ef = EmojipediaFetcher(final_csv_file = final_csv_file)
ef.register('https://emojipedia.org/people/', '/tmp/people.html')
ef.register('https://emojipedia.org/nature/', '/tmp/nature.html')
ef.register('https://emojipedia.org/food-drink/', '/tmp/food-drink.html')
ef.register('https://emojipedia.org/activity/', '/tmp/activity.html')
ef.register('https://emojipedia.org/travel-places/', '/tmp/travel-places.html')
ef.register('https://emojipedia.org/objects/', '/tmp/objects.html')
ef.register('https://emojipedia.org/symbols/', '/tmp/symbols.html')
ef.register('https://emojipedia.org/flags/', '/tmp/flags.html')
ef.generate_emoji_csv_file()
print("Stored all emojis at: %s" % ef.final_csv_file)
