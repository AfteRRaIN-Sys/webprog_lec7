require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user1 = users(:one)
    @user2 = users(:two)
    @post1 = posts(:one)
    @post2 = posts(:two)
    @follow1 = follows(:one)
    @follow2 = follows(:two)
  end

=begin
  test "visiting the index" do

    visit users_url
    assert_selector "h1", text: "Users"
  end

  test "creating a User" do
    visit users_url
    click_on "New User"

    fill_in "Email", with: @user.email
    fill_in "Name", with: @user.name
    click_on "Create User"

    assert_text "User was successfully created"
    click_on "Back"
  end

  test "updating a User" do

    visit users_url
    click_on "Edit", match: :first

    fill_in "Email", with: @user.email
    fill_in "Name", with: @user.name
    click_on "Update User"

    assert_text "User was successfully updated"
    click_on "Back"

  end
  test "destroying a User" do
    visit users_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User was successfully destroyed"
  end

=end

  test "login_success" do
    #register user1
    visit "http://localhost:3000/users/new"
    fill_in "Email", with: "email2"
    fill_in "Name", with: "name2"
    fill_in "Age", with: 10
    fill_in "Password", with: "12345"
    click_on "Create User"
    #register user2
    visit "http://localhost:3000/users/new"
    fill_in "Email", with: "adminemail"
    fill_in "Name", with: "admin"
    fill_in "Age", with: 10
    fill_in "Password", with: "12345"
    click_on "Create User"
    
    visit "http://localhost:3000/main"
    fill_in "Email", with: "adminemail"
    fill_in "Password", with: "12345"
    click_on "Login"
    assert_text "Login Successfully"
  end


  test "login_fail" do
    #register user1
    visit "http://localhost:3000/users/new"
    fill_in "Email", with: "email2"
    fill_in "Name", with: "name2"
    fill_in "Age", with: 10
    fill_in "Password", with: "12345"
    click_on "Create User"
    visit "http://localhost:3000/users/new"
    #register user2
    fill_in "Email", with: "adminemail"
    fill_in "Name", with: "admin"
    fill_in "Age", with: 10
    fill_in "Password", with: "12345"
    click_on "Create User"

    visit "http://localhost:3000/main"
    fill_in "Email", with: "adminemail"
    fill_in "Password", with: "zzzzaaasdda"
    click_on "Login"
    assert_text "Wrong Email or Password!!"
  end

  test "like" do
    #register
    visit "http://localhost:3000/users/new"
    fill_in "Email", with: "email2"
    fill_in "Name", with: "name2"
    fill_in "Age", with: 10
    fill_in "Password", with: "12345"
    click_on "Create User"
    visit "http://localhost:3000/users/new"
    fill_in "Email", with: "adminemail"
    fill_in "Name", with: "admin"
    fill_in "Age", with: 10
    fill_in "Password", with: "12345"
    click_on "Create User"

    #login
    visit "http://localhost:3000/main"
    fill_in "Email", with: "admin"
    fill_in "Password", with: "12345"
    click_on "Login"

    #create new post
    click_on "Create New Post", match: :first
    fill_in "Msg", with: "testmsg"
    click_on "Create Post", match: :first


    #back to feed
    visit "http://localhost:3000/feed"
    click_on "Like", match: :first

    #click on modal
    visit "http://localhost:3000/profile/phetlnw"
    click_on "Liked User", match: :first
    assert_text "phetlnw"
  end


end
