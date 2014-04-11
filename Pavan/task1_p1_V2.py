"""
Task1
"""
from collections import Counter
import re
import operator

STOP_WORDS_FILE = "stop_words.txt"
INPUT_FILE = "deals.txt"
OUTPUT_FILE = "pop_deals.txt"

def get_stopwords():
    """ Module that returns a list of all the stop words"""
    stop_words_file = open(STOP_WORDS_FILE, 'r')
    stop_words = stop_words_file.read().split(',')
    return stop_words
   
def get_popular(text_file, result_filename=None):
    """ Module to find the most popular words from a text file"""
    text_data = open(text_file, 'r')
    # re.findall(r'\w+') would split file into words wrt space and other characters
    words = re.findall(r'\w+', text_data.read().lower())

          
    stop_words = get_stopwords()
    word_counter = Counter(words)
    count_dict = {}
    for word in words:
        if word not in count_dict:
            #ignoring stop_words and digits 
            if not word in stop_words and not word.isdigit():
                # finding the count for the word and adding to the dictionary
                count_dict[word] = word_counter.get(word)

    # Sorting the words in deceasing order based on popularity
    sorted_list = sorted(count_dict.iteritems(), key=operator.itemgetter(1), reverse=True) 

    # Checking for the count of the most popular (in case there are more than one with same count)
    most_popular_count = sorted_list[0][1]
    most_popular_words = []

    for word, curr_count in sorted_list:
        if curr_count == most_popular_count:
            most_popular_words.append(word)
        else:
            break

    # Sorting the words in increasing order based on popularity
    sorted_list = sorted(count_dict.iteritems(), key=operator.itemgetter(1)) 

    # Checking for the count of the least popular (in case there are more than one)
    least_popular_count = sorted_list[0][1]
    least_popular_words = []
    for word, curr_count in sorted_list:
        if curr_count == least_popular_count:
            least_popular_words.append(word)
        else:
            break

        
    if result_filename:
        result_file = open(result_filename, "w")
        result_file.write("Most popular term and its count\n")
        for word in most_popular_words:
            result_file.write(",".join((word, str(most_popular_count))) + "\n" )
        
        result_file.write("\nLeast popular terms and their count\n")
        for word in least_popular_words:
            result_file.write(",".join((word, str(least_popular_count), "\n")))

    return (most_popular_words, most_popular_count), (least_popular_words, least_popular_count)    


#Calling the function to generate a file with the most and ,east popular words 
get_popular(INPUT_FILE, OUTPUT_FILE)   
    


    
    


    

    
    
    
    
    
    

    
