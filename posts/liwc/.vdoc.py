# type: ignore
# flake8: noqa
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| label: sentiment-on-strings
import re
def load_liwc_list(filepath):
    """
    :return: A list of words loaded from the file at `fpath`
    """
    with open(filepath, 'r', encoding='utf-8') as infile:
        words = infile.read().split()
    return words

def liwc_to_regex(liwc_list):
    """
    Converts LIWC expression list into Python regular expression
    """
    wildcard_reg = [w.replace('*', r'[^\s]*') for w in liwc_list]
    reg_str = r'\b(' + '|'.join(wildcard_reg) + r')\b'
    return reg_str

def num_matches(reg_str, test_str):
    num_matches = len(re.findall(reg_str,test_str))
    return num_matches

def file_to_regex(filepath):
    liwc_list = load_liwc_list(filepath)
    liwc_regex_list = liwc_to_regex(liwc_list)
    return liwc_regex_list

# You can call the following helper function if
# you'd like to see the full regular expression
def print_regex(regex_str, wrap_col=70):
    import textwrap
    print(textwrap.fill(regex_str, wrap_col))
#
#
#
#
#
#| label: disp-regex
pos_fpath = "./assets/liwc/031-posemo.txt"
pos_regex = file_to_regex(pos_fpath)
neg_fpath = "./assets/liwc/032-negemo.txt"
neg_regex = file_to_regex(neg_fpath)
# Uncomment this line to see the full regular expression
#print_regex(neg_regex)
print_regex(neg_regex[:140])
#
#
#
#
#
#| label: count-pos-neg
def extract_sentiment_data(text):
    # First compute positive sentiment using pos_reg
    pos_count = num_matches(pos_regex, text)
    # Then negative sentiment using neg_reg
    neg_count = num_matches(neg_regex, text)
    # And finally the overall sentiment score as the difference
    sentiment = pos_count - neg_count
    return {
        'pos': pos_count,
        'neg': neg_count,
        'sentiment': sentiment
    }

def compute_sentiment(text):
    full_results = extract_sentiment_data(text)
    # Return just the overall sentiment score
    return full_results['sentiment']
#
#
#
#
#
#| label: test-strings
neg_test_str = "Python is terrible, I hate Python, I despise Python"
neg_str_results = extract_sentiment_data(neg_test_str)
print(f"{neg_test_str}\n{neg_str_results}")
pos_test_str = "Python is wonderful, I love Python, I adore Python"
pos_str_results = extract_sentiment_data(pos_test_str)
print(f"{pos_test_str}\n{pos_str_results}")
neutral_test_str = "Python is ok, Python is mid, I guess I can do Python maybe"
neutral_str_results = extract_sentiment_data(neutral_test_str)
print(f"{neutral_test_str}\n{neutral_str_results}")
#
#
#
#
#
#| label: create-df
import pandas as pd
text_df = pd.DataFrame({
    'text_id': [1,2,3],
    'text': [neg_test_str, pos_test_str, neutral_test_str]
})
text_df
#
#
#
#| label: sentiment-on-df
text_df['sentiment'] = text_df['text'].apply(compute_sentiment)
text_df
#
#
#
#
