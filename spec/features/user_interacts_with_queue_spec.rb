require "spec_helper"

feature "User interacts with the queue" do
  scenario "user adds and reorders videos in the queue" do
    category = Fabricate(:category)
    video1 = Fabricate(:video, title: "vodeo1", category: category)
    video2 = Fabricate(:video, title: "video2", category: category)
    video3 = Fabricate(:video, title: "video3", category: category)

    sign_in
    #require "pry" ; binding.pry
    add_video_to_queue(video1)
    expect_video_to_be_in_queue(video1)

    visit video_path(video1)
    expect_link_not_to_be_seen("+ My Queue")


    add_video_to_queue(video2)
    add_video_to_queue(video3)

    set_video_position(video1, 3)
    set_video_position(video2, 1)
    set_video_position(video3, 2)

    # 
    #     find("input[data-video-id='#{video1.id}']").set(3)
    #     find("input[data-video-id='#{video2.id}']").set(1)
    #     find("input[data-video-id='#{video3.id}']").set(2)

    # fill_in "video_#{video1.id}", with: 3
    # fill_in "video_#{video2.id}", with: 1
    # fill_in "video_#{video3.id}", with: 2

    update_queue

    expect_video_position(video1, 3)
    expect_video_position(video2, 1)
    expect_video_position(video3,2)


  end

  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(., '#{video.title}')]//input[@type='text']").value).to eq(position.to_s) 

  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in "queue_items[][position]", with: position 
    end
  end

  def add_video_to_queue(video)
    visit home_path
    click_on_video_on_home_page(video)
    click_link "+ My Queue"
  end

  def expect_video_to_be_in_queue(video)
    page.should have_content(video.title)
  end

  def expect_link_not_to_be_seen(link_text)
    page.should_not have_content(link_text)
  end

  def update_queue
    click_button "Update Instant Queue"
  end
end
