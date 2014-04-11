"""
Task3: How many types of guitars are mentioned across all the deals?

"""

from task1_p1_V2 import get_stopwords
import re

# Words that are not in stop_words but need to be ignored
IGNORE_WORDS = ['shop', 'online', 'hd', 'learn', 'buy', 'get', 'sell'] 

# File to store the types of guitars
OUTPUT_FILE = "guitars_types.txt"

def get_guitars(text_file, guitar_filename=None):
    """ Module to find the most popular words from a text file"""
    text_data = open(text_file, 'r')
    # Finding all the occurances of 'guitar' and its preceiding words
    guitars = re.findall(r'\w+ guitar', text_data.read().lower())
    guitars_no_duplication = set(guitars)
    if guitar_filename:
        guitar_file = open(guitar_filename, 'w')
    stop_words = get_stopwords()
    _digits = re.compile('\d')
    count = 0
    for guitar in guitars_no_duplication:
        # Ignore if the word preceiding guitar is a stop_word
        guitar_type = guitar.split()[0]
        if guitar_type in stop_words:
            continue
        if guitar_type in IGNORE_WORDS :
            continue
                      
        # Ignore if the preceiding word has digits
        if bool(_digits.search(guitar_type)):
            continue
         
        
        if guitar_filename:
            guitar_file.write(guitar+"\n")
        count += 1
        print guitar
    print "The total number of types of guitars are %d" %(count)

get_guitars("deals.txt", OUTPUT_FILE)
