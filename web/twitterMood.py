# importing the requests library
from twython import Twython
from datetime import datetime
import json
import time
import requests

APP_KEY = '60ggHztC3ViJfj6hnaVycTnvN';
APP_SECRET = 'NwbjbzXWgpF9QRm0uK8UYxbdFQEnCKwyZUIpDtINGwV73weGPt';

twitter = Twython(APP_KEY, APP_SECRET);
auth = twitter.get_authentication_tokens();
OAUTH_TOKEN = auth['oauth_token'];
OAUTH_TOKEN_SECRET = auth['oauth_token_secret'];


#Emotion analysis settings and queries
emotionNames = ['Love', 'Joy', 'Surprise', 'Anger', 'Envy', 'Sadness', 'Fear'];
emotionTweetsPerMin = [];
baseLineEmotions = [0.13, .15, 0.20, 0.14, 0.16, 0.12, 0.10];
emotionSmoothingFactor = .01;
moodSmoothingFactor = .05;
moderateMoodThreshold = 2;
extremeMoodThreshold = 4;
delay = 5;

searchQueries = []
searchQueries.append('\"i+love+you\"+OR+\"i+love+her\"+OR+\"i+love+him\"+OR+\"all+my+love\"+OR+\"i\'m+in+love\"+OR+\"i+really+love\"');
searchQueries.append('\"happiest\"+OR+\"so+happy\"+OR+\"so+excited\"+OR+\"i\'m+happy\"+OR+\"woot\"+OR+\"w00t\"');
searchQueries.append('\"wow\"+OR+\"O_o\"+OR+\"can\'t+believe\"+OR+\"wtf\"+OR+\"unbelievable\"');
searchQueries.append('\"i+hate\"+OR+\"really+angry\"+OR+\"i+am+mad\"+OR+\"really+hate\"+OR+\"so+angry\"');
searchQueries.append('\"i+wish+i\"');
searchQueries.append('\"i\'m+so+sad\"+OR+\"i\'m+heartbroken\"+OR+\"i\'m+depressed\"+OR+\"can\'t+stop+crying\"+OR+\"i\'m+tired\"+OR+\"life+sucks\"+OR+\"i\'m+so+done\"+OR+\"fml\"');
searchQueries.append('\"i\'m+so+scared\"+OR+\"i\'m+really+scared\"+OR+\"i\'m+terrified\"+OR+\"i\'m+really+afraid\"+OR+\"so+scared+i\"+OR+\"scared\"+OR\"afraid\"');
rpp = '60';
resultType = 'recent';

worldMood = -1;
moodIntensity = '';
rateRatios = [-1, -1, -1, -1, -1, -1, -1];



#Find and return the tweets per min rate
def getTweetRate(index):
    data = twitter.search(q=searchQueries[index], count=rpp, result_type=resultType);
    firstTweet = (data['statuses'][0])['created_at'];
    lastTweet = (data['statuses'][len(data['statuses'])-1])['created_at'];
    firstTweetTime = datetime.strptime(firstTweet, "%a %b %d %H:%M:%S %z %Y");
    lastTweetTime = datetime.strptime(lastTweet, "%a %b %d %H:%M:%S %z %Y");
    diff = firstTweetTime-lastTweetTime;
    #print(diff);
    return float(rpp) / diff.total_seconds() * 60.0;

def currMood():
    tempMood = -1;
    sumRate = sum(emotionTweetsPerMin)
    for x in range(len(emotionTweetsPerMin)):
        rateRatios[x] = (emotionTweetsPerMin[x] / sumRate);
    maxIncrease = -1;
    for x in range(len(rateRatios)):
        difference = (rateRatios[x] - baseLineEmotions[x]) / baseLineEmotions[x];
        if difference > maxIncrease:
            maxIncrease = difference;
            tempMood = x
    sumRate = 0.0;
    for x in range(len(baseLineEmotions)):
        baseLineEmotions[x] = (baseLineEmotions[x] * (1.0 - moodSmoothingFactor)) + (rateRatios[x] * moodSmoothingFactor);
        sumRate += rateRatios[x];
    for x in range(len(baseLineEmotions)):
        baseLineEmotions[x] *= 1.0 / sumRate;
    return tempMood;

def currMoodIntensity():
    percent = rateRatios[worldMood] / baseLineEmotions[worldMood];
    if percent > extremeMoodThreshold:
        return 'extreme';
    if percent > moderateMoodThreshold:
        return 'modernate';
    return 'mild';

def main():
    for x in range(len(emotionNames)):
        emotionTweetsPerMin.append(getTweetRate(x));
    for i in range(10):
        print("loop:",i+2);
        for x in range(len(emotionNames)):
            emotionTweetsPerMin[x] = (emotionTweetsPerMin[x] * (1.0 - emotionSmoothingFactor)) + (getTweetRate(x) * emotionSmoothingFactor);
            worldMood = currMood();
            moodIntensity = currMoodIntensity();
            #time.sleep(delay)
    print(moodIntensity);
    print(emotionNames[worldMood]);
    print(rateRatios);
    API_ENDPOINT = "http://projectscale.me/globalData/SwFaJKpAMIaKhIz4vS4FCnYvTj33"
    data = {
        'intensity': moodIntensity,
        'mood': emotionNames[worldMood],
        'ratios': rateRatios
    }
    r = requests.post(url = API_ENDPOINT, data = data);
    print(r);

if __name__ == "__main__":
    main()
