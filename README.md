# IOS-NIBM-FoodCafe

#How to use

Upon first opening the app the user will navigation location request screen and ask to provide location permisssion.
Upon providing the permission, if the permission is denied then user will navigated to settings screen.in success path, the user will be navigated to Sign up screen.
In the same screen user can either sign in or sign up, user can toggle the screen with (register? and login?) secondary button. After the user has logged in the user will be navigated
to main Food list screen.User can browse any food item and click item to see more detail.When viewing more details about a certain food the user can tap "add to cart" button and user navigated
back to food screen list and a item is added to cart and a button will apear - which is the order button with total cost sum of items in the cart. Upon changing the quantities of items in the
cart, user can finally tap the order button.Then user will be navigated to order tab screen and user can see the order with new orderID.At this point in the database the status of the particular order should
be updated to value other than (1 - 3) and order will be treated as proccessed and will be moved to account screen and user can view their passed order with description.
In the account screen user can change profile picture by tapping the avatar, phone number and display name by tapping the text.Also user can filter the history based on date range.
