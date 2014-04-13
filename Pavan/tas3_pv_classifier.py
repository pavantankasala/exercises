    """ Intial try was to extract statistical features resimbling the randomness of the feature
        vector. So chose mean, variance, entropy and median as features and performed
        simle classification.
        Training set used was 70% of the training data and 30% was for validation ,
        Used Decsion trees as Intial classifier.
         """
    
import nltk
import random
import numpy as np

GOOD_DEALS_FILE = "good_deals_ascii.txt"
#GOOD_DEALS_FILE = "good_deals_clean.txt"
BAD_DEALS_FILE = "bad_deals_ascii.txt"
#BAD_DEALS_FILE = "bad_deals_clean.txt"
#TEST_DEALS_FILE = "test_deals_feature_list.txt"

FEATURE_KEY = 'words'


def entropy(X):
    probs = [np.mean(X == c) for c in set(X)]
    return np.sum(-p * np.log2(p) for p in probs)


def feature_extractor(deal):
    """ MOdule to extract the features of a deal"""

    data = [int(c) for c in deal.strip().split(',')]
    stats = np.mean(data), np.median(data), np.var(data), entropy(data)
    return {FEATURE_KEY : (deal)}

def get_classifier(good_deals_file, bad_deals_file):
    """Module to get the train set """
    feature_set = []
    good_deals = open(good_deals_file, 'r')
    for deal in good_deals.readlines():
        feature = feature_extractor(deal)
        feature_set.append((feature, 'good'))

    bad_deals = open(bad_deals_file, 'r')
    for deal in bad_deals.readlines():
        feature = feature_extractor(deal)
        feature_set.append((feature, 'bad'))
    random.shuffle(feature_set)

    train_set, validation_set = (feature_set[:int(len(feature_set)*7/10)],
                            feature_set[int(len(feature_set)*7/10):])
    
    classifier = nltk.DecisionTreeClassifier.train(train_set)
    return classifier, validation_set

def main():
    classifier, validation_set = get_classifier(GOOD_DEALS_FILE, BAD_DEALS_FILE)

    for deal, correct_deal_class in validation_set:
        feature = feature_extractor(deal[FEATURE_KEY])
        predict_deal_class = classifier.classify(feature)
        print "correct: %s predict %s" %( correct_deal_class, predict_deal_class)

def classify_deal(classifier, deal):
    return classifier.classify(feature_extractor(deal))

main()
