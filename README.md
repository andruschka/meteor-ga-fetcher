# Google Analytics Fetcher
Fetch data from Google Analytics, synchronously.  
Uses the official googleapis.
```
meteor add andruschka:ga-fetcher
```

```
var ga = new GaFetcher(Meteor.settings.gapiOpts);
query ={
  'start-date': '2015-01-19',
  'end-date': '2015-01-19',
  'metrics': 'ga:visits'
};
var data = ga.fetchData(query);
console.log(data);

```
  
Before using read [this](http://stackoverflow.com/questions/18679486/accessing-google-analytics-through-nodejs).  
Helped me alot with creating the XXX.pem file...