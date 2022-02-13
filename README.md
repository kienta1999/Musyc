# iOS_Development_Final_Project: MUSYC

### Team members: Xiaoyu Liu, Hang Su, Anh Le, Kien Ta

### Description: 
This is a music player application implemented three APIs that can search and download music, play music online and show lyrics if it exits. We also have an icon on home page. 

### There are five tabs for our app:

1. Download tab: 
- User can search and download music from NeteaseCloudMusicApi, share the same layout with search. Once click on download, you can search a music and the result will be shown in tableview. Click on table cell will go to a detail page. Click download can download file. The downloaded file will be saved to File application and renamed to the song’s name.
- An unsuccesful download will alert user.

2. Search tab:
- User can search music on Spotify, can go to detail page. Songs with lyrics available will show up at below. Click Stream will go to Spotify page and can listen to music online. Click the button on right top can add music to favorite after log in. Otherwise, you will be prompted to log in.
<p><img src="Images/Song Search.png" alt=""></p>
3. Album tab:
- Similar to search, album tab can search albums on Spotify and listen online.
 <p><img src="Images/Album Search.png" alt=""></p> 
4. Song details
User can see the detail of the songs and stream it in spotify
<p><img src="Images/Song details.png" alt=""></p>
<p><img src="Images/Song Stream.png" alt=""></p>
 4. Favorite tab:
- You can find your favorite online songs here after login. Click on the song will go to the detail page. You can right drag the song to delete it from the table, you can also clear the table by clicking “clear”.
- The list is saved locally and won’t lose if you close the app.
- If you are not log in, a login page will show up to prompt you to log in. 
<p><img src="Images/Favourite List.png" alt=""></p>
5. User tab:
- You can log in, sign up, or sign out at this tab. Once click, a login page will show up to prompt you to log in. Click “skip” will redirect you to the first tab.  Or you can sign in by “sign in”, and “sign up” by “sign up”.  Once you sign in, you don’t need to sign in again if you close the app and reopen it. Instead, you will see a welcome page. You can sign out by click sign out button.
