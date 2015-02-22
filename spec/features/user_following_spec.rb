require "spec_helper"

feature "User following" do
  scenario "user follows and unfollows someone" do

    user = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    Fabricate(:review, user: user, video: video)

    sign_in
    click_on_video_on_home_page(video)

    click_link user.full_name
    click_link "Follow"
    expect(page).to have_content(user.full_name)
    unfollow(user)
    expect(page).not_to have_content(user.full_name)
  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end
end
