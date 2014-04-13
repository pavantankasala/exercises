"""Task 2 organizing the data into groups
   data is organized into two groups, they are
   1) Nouns( carrying item information )
   2) stop words(least significant words)
"""
import numpy as np
import textblob
import nltk
from textblob import TextBlob
from task1_p1_V2 import get_stopwords

DATA_FILE = 'C:\\Users\\SAIRAM\\Dropbox\\MachineLearning\\deals.txt'
NOUN_OUTPUT_FILE = 'C:\\Users\\SAIRAM\\Dropbox\\MachineLearning\\deals_out_nouns_task2.txt'
STORE_WORDS_FILE = 'C:\\Users\\SAIRAM\\Dropbox\\MachineLearning\\deals_out_stop_task2.txt'

def noun_parsing(data_file):
    """Acquiring nouns from deal data"""
    data = open(data_file,'r')
    data_read = data.readlines()
    x2=set()
    for line in data_read:
        sel_line=TextBlob(line)
        x2=x2.union(set(sel_line.noun_phrases))
    print "writing"
    output = open(NOUN_OUTPUT_FILE,'w')
    for elm in x2:
        output.write(elm + '\n')
    output.close()


def store_stop_words(data_file):
    """ Acquiring stop words from deals data"""    
    stop_words_list = get_stopwords()
    
    data = open(data_file,'r')
    data_read = data.readlines()
    x2 = set()
    for line in data_read:
        for word in line.split():
            if word in stop_words_list:
                x2.add(word)
    data.close()
    print "writing"
    output = open(STORE_WORDS_FILE,'w')
    for elm in x2:
        output.write( elm + '\n')
             
    output.close()    

noun_parsing(DATA_FILE)
store_stop_words(DATA_FILE)
