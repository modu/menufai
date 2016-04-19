## User Stories
Menufai is designed to give its users information about the listings on any restaurant menu. The user will capture an image of the menu listings, and the output is given as a collection view of images that corresponds to what was in the image of the menu.  
Final Presentation Video:
https://www.youtube.com/watch?v=nITRck0UYeo

Required User Stories

- [x] User can take an image and it can be sent to the image processor
- [x] Image processor parses out keywords of the image into usable code (ie., Strings)
- [x] String output from the image processor is searched on Google and the results should be returned and stored in a view
- [x] User can push an image, modal pops up with nutritional values, [s]vegan (or not), etc.[/s]

Optional User Stories

- [ ] User can filter out results (ie., vegan, Gluten-free, etc.)
- [ ] User can select a smaller area to capture on the camera
- [ ] User can push on an image and scroll through that particular image to see other images of it returned from Google search
- [ ] App can detect multiple languages

https://trello.com/b/jcfM63hD/menufai-user-story

![alt tag](http://imgur.com/3MOLG8G.jpg "A draw up")

## Data Scheme and APIs Used
Google Custom Search
https://developers.google.com/custom-search/json-api/v1/overview
Example JSON:
https://www.googleapis.com/customsearch/v1?cx=011903584210993207937:bz3dg769ssy&q=BACON&key=AIzaSyCUXq0S6_wp1AtZy2vLNDpVCV1Opsapu1M&searchType=image
Properties used: items, link

Nutritionix
https://developer.nutritionix.com/docs/v1_1
Example JSON:
https://api.nutritionix.com/v1_1/search/BACON?fields=item_name%2Citem_id%2Cbrand_name%2Cnf_calories%2Cnf_total_fat&appId=f043c24d&appKey=8897be9dbacaa535e0cba2ea6b4d4d44
Properties used: total_hits, hits, fields, item_name, brand_name, nf_calories, nf_total_fat
