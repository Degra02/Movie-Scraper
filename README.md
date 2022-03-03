# Movie-Scraper

Movie scraping application written in [Dart](https://dart.dev/) using the [Flutter](https://flutter.dev/) framework.  
Displays latest movies based on popularity and genre.   
The application also includes a search-by-title function.


## API
The application uses [The Movie Database](https://www.themoviedb.org) API to get the movies data.

In order to use the application, you will need to request an API Key from The Movie Database.  

[This Link](https://www.themoviedb.org/documentation/api) contains the informations on how to get one.  
Then replace all *api.api_key* from [http_functions.dart](./lib/http_functions.dart) with a String variable like this --> String apiKey = 'api_key=[YOUR API KEY]';
