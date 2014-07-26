# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
c1 = Category.create(:name => 'TV Commedies')
c2 = Category.create(:name => 'TV Dramas')
c3 = Category.create(:name => 'Reality TV')

Video.create(title: "Family Guy", description: "Family Guy is an American adult animated sitcom created by Seth MacFarlane for the Fox Broadcasting Company. The series centers on the Griffins, a family consisting of parents Peter and Lois; their children Meg, Chris, and Stewie; and their anthropomorphic pet dog Brian. The show is set in the fictional city of Quahog, Rhode Island, and exhibits much of its humor in the form of cutaway gags that often lampoon American culture." ,large_cover_url: "tmp/family_guy.jpg", small_cover_url: "tmp/family_guy.jpg", category: c1 )
Video.create(title: "Futurama", description: "Futurama is an American adult animated science fiction sitcom created by Matt Groening and developed by Groening and David X. Cohen for the Fox Broadcasting Company." ,large_cover_url: "tmp/futurama.jpg", small_cover_url: "tmp/futurama.jpg", category: c2)
Video.create(title: "Monk", description: "Monk is an American comedy-drama detective mystery television series created by Andy Breckman and starring Tony Shalhoub as the eponymous character, Adrian Monk." ,large_cover_url: "tmp/monk_large.jpg", small_cover_url: "tmp/monk.jpg", category: c3)



Review.create(user_id: 1, video_id: 3, rating: 4, content: "In my opinion, this is one of the best shows ever made. It's not only funny, but despite being so frequently silly, it's very smart as well. Math, science, history, all get referenced. The best parts of the show are the subtle things, those little things in the background or just on screen for a couple of seconds that just make you laugh out loud if you were paying attention. The writers even appear to have been thinking ahead, because if you play close attention to the first episode, you can see a literal shadow of an event revealed seasons later")
Review.create(user_id: 1, video_id: 3, rating: 5, content: "Seriously, what shows have been that great in the past few years, that could appeal to just about any person? Monk delivers laughs and mysteries to a wide range of audiences. Experts on O.C.D. (Obsessive Compulsive Disorder) say that the show does a credit to all patients in this field, instead of insulting and making fun of them, as many shows and movies do.")
Review.create(user_id: 1, video_id: 3, rating: 3, content: "Tony Shalhoub plays Monk perfectly. Monk isn't your average detective. His wife was killed in a car explosion 3 year ago. He suffered a major breakdown and is now trying to get reinstated on the police force with the help of his private nurse. Monk's got lots of problems. He is Obsessive Compulsive, has fear of crowds, heights, the dark, and milk. Yes milk. Yet he is the greatest detective around. In one episode he even tried to straighten up the crime scene because the mess was driving him crazy.")

QueueItem.create(user_id: 1, video_id: 2, position:1)
QueueItem.create(user_id: 1, video_id: 3, position:2)
