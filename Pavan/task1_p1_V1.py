"""
Task1


"""

from collections import Counter
import re

STOP_WORDS_FILE = "stop_words.txt"

def get_stopwords():
    """ Module that returns a list of all the stop words"""
    stop_words_file = open(STOP_WORDS_FILE, 'r')
    stop_words = stop_words_file.read().split(',')
    return stop_words

   
def get_popular(text_file, count):
    """ Module to find the most popular words from a text file"""
    text_data = open(text_file, 'r')
    words = re.findall(r'\w+', text_data.read().lower())
    words_no_duplication = set(words)
    
    stop_words = get_stopwords()
    word_counter = Counter(words)
    count_dict = {}
    for word in words_no_duplication:
        if not word in stop_words:
            count_dict[word] = word_counter.get(word)
    # Sorting the words in deceasing order based on popularity
    sorted_count = sorted(count_dict, key=count_dict.get, reverse=True)
    most_popular = sorted_count[:count]
    least_popular = sorted_count[-count:]
    return most_popular, least_popular


print get_popular("deals.txt", 1)
    


    
    


    

    
    
    
    
    
    

    
