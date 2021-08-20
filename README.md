# Single Sign On Server - Demo

### What it can be used for?
Login in in one place and share the session to all domains needed.

### How it works?
There are 3 separate apps:
1. auth server - start it on port 3000 `rails s`
2. store test 1 - start it on port 3001 `rails server -p 3001`
3. store test 2 - start it on port 3002 `rails server -p 3002`
   
Before starting any server `bundle install` and run the migrations on each app `rails db:migrate`, and create a user on `auth` app running: `User.create!(email: 'example@mail.com' , password: '123123123' , password_confirmation: '123123123')`

Start all 3 servers in different terminals as mentioned above.

When we need to login we visit `http://localhost:3000/login`, and enter the details from the user created earlier.

Once we are logged in we can visit both `http://localhost:3001` or `http://localhost:3002` and we will see the user details.
###### What happened under the hood?
- Assuming that we visited `http://localhost:3001`
- We'll be redirected to the auth server `http://localhost:3000?redirect_url=localhost:3001`
  
  note the redirect_url parameter 
  
- We'll check if we have a session[:user_id]
  1. If we do have, we redirect back to the url from params (`:redirect_url`) `http://localhost:3001?token=[auth-token]`
     - Having a token will make a request back to auth server `http://localhost:3000/verify-token` where we decode that token and retrieve user info
  2. If we do NOT have, we redirect back with `http://localhost:3001?token=[no-user]`
    
- If we already have a session[:user_id] on `http://localhost:3001` (ex. next time we visit), we'll make a request to the auth server `http://localhost:3000/load-user` where we're finding the user and retrieve the user info (to reduce redirects).

### More info
https://tushartuteja.medium.com/a-simple-single-sign-on-sso-using-rails-docker-ff62187b959