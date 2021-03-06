require 'factory_girl'
require Rails.root.join("spec/support/factory_helper.rb")
Dir[Rails.root.join("spec/factories/*.rb")].each {|f| require f}


include ActionDispatch::TestProcess

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Tags
year_group_tags = [ '1st Year', '2nd Year', '3rd Year', '4th Year' ]
skills_tags = [ 'C', 'C++', 'Java', 'Ruby', 'Haskell' ]
interests_tags = [ 'Web Development', 'Banking', 'Games Development', 'Business' ]

computing_department = FactoryGirl.create :department, {
  name: "Department of Computing",
  settings_notifier_placement: "If this is your first placement you're offering, make sure you send back a placement performa and a health and safety form which can be found on https://www.doc.ic.ac.uk/internal/industrialplacements/employers/IPproforma12-studentorganised.doc and https://www.doc.ic.ac.uk/internal/industrialplacements/employers/Placement_Provider_Information_Form_2012.doc",
  settings_notifier_event: "Please note that at current an event must be scheduled at least two weeks in advance to be approved."
}

oliver = FactoryGirl.create :student,  {
  first_name: "Oliver",
  last_name: "Grubin",
  email: "oliver.grubin14@imperial.ac.uk",
  password: "cppcppcpp",
  password_confirmation: "cppcppcpp",
  year: 2015,
  bio: "Placeholder Text",
  course_id: 14,
  cid: "og514"
}

oliver.skill_list = ["Ruby on Rails", "Backbone.js", "Java", "Coffeescript", "Javascript", "HTML", "CSS"]
oliver.interest_list = ["Web Dev", "Startups", "iOS Dev", "Open Source"]
oliver.year_group_list = ["3rd Year", "MEng"]
oliver.save!

isb14 = FactoryGirl.create :student,  {
  first_name: "Ian",
  last_name: "Billett",
  email: "isb14@ic.ac.uk",
  password: "cppcppcpp",
  password_confirmation: "cppcppcpp",
  year: 2015,
  bio: "Placeholder Text.",
  course_id: 14,
  cid: "isb14"
}

isb14.skill_list = skills_tags
isb14.interest_list = interests_tags
isb14.year_group_list = ["3rd Year", "MEng"]
isb14.save!

hwl214 = FactoryGirl.create :student,  {
  first_name: "Hugh",
  last_name: "Lunt",
  email: "hwl214@ic.ac.uk",
  password: "cppcppcpp",
  password_confirmation: "cppcppcpp",
  year: 2015,
  bio: "Placeholder Text.",
  course_id: 14,
  cid: "hwl214"
}

sg5414 = FactoryGirl.create :student,  {
  first_name: "Sam",
  last_name: "Green",
  email: "sg5414@ic.ac.uk",
  password: "cppcppcpp",
  password_confirmation: "cppcppcpp",
  year: 2015,
  bio: "Placeholder Text.",
  course_id: 14,
  cid: "sg5414"
}

al4209 = FactoryGirl.create :student,  {
  first_name: "Henry",
  last_name: "Lake",
  email: "al4209@ic.ac.uk",
  password: "cppcppcpp",
  password_confirmation: "cppcppcpp",
  year: 2015,
  bio: "Placeholder Text.",
  course_id: 14,
  cid: "al4209"
}

hwl214.skill_list = skills_tags
hwl214.interest_list = interests_tags
hwl214.year_group_list = ["3rd Year", "MEng"]
hwl214.save!
sg5414.save!
al4209.save!

FactoryGirl.create :company, {
  name: 'Google',
  description: 'At Google, you have the opportunity to do impactful and challenging work no matter where you are. Our engineers work on exciting, cutting-edge computer science problems. We are also looking for the brightest minds in media, sales, marketing, finance and product management to help us change the world. We hire at all levels of academic experience for opportunities throughout Europe, Middle East and Africa including Dublin, London, Tel Aviv, Wroclaw and Zurich.',
  reg_status: 3
}

FactoryGirl.create :company, {
  name: 'Amazon',
  description: "Technological innovation drives the growth of Amazon and we're delighted to be offering exciting internship and graduate opportunities for Software Development Engineers. Whether it's in our UK Headquarters or Development Centres (Edinburgh, Dublin, Central London) or Seattle, you could be working on a number of initiatives for Amazons global websites and services. For ambitious graduates, like you, intent on developing a successful career, the result is a technical learning environment quite unlike any other. Work Hard. Have Fun. Make History. To find out more see our UK Opportunities and our US Opportunities.",
  reg_status: 3
}

FactoryGirl.create :company, {
  name: 'Facebook',
  description: "At Facebook our development cycle is extremely fast, and we've built tools to keep it that way. It's common to write code and have it running on the live site a few days later. This comes as a pleasant surprise to engineers who have worked at other companies where code takes months or years to see the light of day. You can help build the next-generation systems behind Facebook's products, create web applications that reach millions of people, build high volume servers and be a part of a team that's working to help people connect with each other around the globe. Join us!",
  reg_status: 3
}

FactoryGirl.create :company, {
  name: 'IBM',
  description: "IBM is the world leader in IT services and consultancy. Across industries including business, finance, health, retail, sport, media and entertainment, it's likely that an IBM system or solution is helping to provide the service. We offer a Graduate Scheme, Industrial Trainee Placement Scheme and Extreme Blue Summer Internship programme. Applications are now being accepted on our recruitment website for Graduate Software Development roles and Graduate Information Developer roles, as well as our 12-week Extreme Blue Summer internships. We will be in touch with all students who register interest with us through the website.",
  reg_status: 3
}

FactoryGirl.create :company, {
  name: 'Intel',
  description: "Intel, the world leader in silicon innovation, develops technologies, products, and initiatives to continually advance how people work and live. Founded in 1968 to build semiconductor memory products, Intel introduced the world's first microprocessor in 1971, and had a net revenue of $54 billion in 2011. Intel's mission this decade is to create and extend computing technology to connect and enrich the lives of every person on earth. Intel's European research and development network, Intel Labs Europe, consists of more than 40 labs employing more than 3700 R&D professionals working on subjects from semi-conductor physics to mobile-phone user-experience research, so whatever your area of interest you'll find people at Intel who want your expertise. As an Intel employee you will be able to contribute to real innovation in products that everyone uses.",
  reg_status: 3
}

FactoryGirl.create :company, {
  name: 'Microsoft',
  description: "Microsoft Research Cambridge is one of the largest computer science research laboratories in Europe, the Middle East and Africa (EMEA). With over 100 leading researchers from around the world across various disciplines, we work hard to provide a world-class academic environment that promotes creativity and independent thinking, while providing a challenging and open work environment.",
  reg_status: 3
}

FactoryGirl.create :company, {
  name: 'Netcraft',
  description: "Netcraft is an Internet services company based in Bath which provides Internet data mining, defences against fraud and phishing, web application security testing, and automated penetration testing. Clients include many of the world's leading Internet infrastructure and financial companies, and in particular, Netcraft's anti-phishing services are very widely licensed, ultimately protecting hundreds of millions of people.",
  reg_status: 3
}

FactoryGirl.create :company, {
  name: 'NextJump',
  description: "Next Jump are a world leading web development company, providing corporate reward sites for most of the largest and most prestigious organisations in the FTSE100 including BT, HSBC, RBS, GSK and many more. We are looking for technology rockstars who are driven and enthusiastic and have a passion for cutting edge technology. Based in London, you'll be joining a fast-paced and rapidly-growing company that aims to make itself the best place to work in the world and therefore offer great perks such as free healthy breakfast, snacks and dinner every day, at least two trips a year to the head office in New York, private healthcare, gym membership, free laundry service etc.",
  reg_status: 3
}

FactoryGirl.create :company, {
  name: 'Palantir',
  description: "Palantir is inspired by a simple idea: that with good technology and enough data, intelligent people can find new solutions to hard problems and change the world for the better. For organizations addressing many of today's most critical challenges, the necessary information is already out there, waiting to be understood. We build technology that allows people to make sense of their data, equipping them with the intelligence they need for their missions to succeed. Palantir's current customers are a mix of government agencies, financial institutions and non-profits. Collectively, their impact on the world is so large it's difficult to measure, and we're proud that our work contributes to that impact. We change the world for the better by writing software that reveals intelligence hidden within hairy, complex systems - but the software is merely the means to our end of solving the world's biggest problems.",
  reg_status: 3
}

FactoryGirl.create :company, {
  name: 'VMware',
  description: "VMware, the global leader in virtualization and cloud infrastructure, delivers customer-proven solutions that accelerate IT by reducing complexity and enabling more flexible, agile service delivery. VMware enables enterprises to adopt a cloud model that addresses their unique business challenges. VMware's approach accelerates the transition to cloud computing while preserving existing investments and improving security and control. With more than 350,000 customers and 50,000 partners, VMware solutions help organizations of all sizes lower costs, increase business agility and ensure freedom of choice.",
  reg_status: 3
}

FactoryGirl.create :course, {
  name: 'Computing (BEng)',
}

FactoryGirl.create :course, {
  name: 'Computing (MEng)',
}

FactoryGirl.create :course, {
  name: 'Computing - Artificial Intelligence (MEng)',
}

FactoryGirl.create :course, {
  name: 'Computing - Computation in Biology and Medicine (MEng)',
}

FactoryGirl.create :course, {
  name: 'Computing - Games, Vision and Interaction (MEng)',
}

FactoryGirl.create :course, {
  name: 'Computing - International Programme of Study (MEng)',
}

FactoryGirl.create :course, {
  name: 'Computing (Computational Management) (MEng)',
}

FactoryGirl.create :course, {
  name: 'Computing - Software Engineering (MEng)',
}

FactoryGirl.create :course, {
  name: 'Mathematics and Computer Science (BEng)',
}

FactoryGirl.create :course, {
  name: 'Mathematics and Computer Science (BEng)',
}

FactoryGirl.create :course, {
  name: 'Mathematics and Computer Science (MEng)',
}

FactoryGirl.create :course, {
  name: 'Mathematics and Computer Science - Pure Maths and Computational Logic (MEng)',
}

FactoryGirl.create :course, {
  name: 'Mathematics and Computer Science - Computational Statistics (MEng)',
}

FactoryGirl.create :course, {
  name: 'MSc in Computing Science',
}

FactoryGirl.create :course, {
  name: 'MSc in Advanced Computing',
}

FactoryGirl.create :course, {
  name: 'MSc in Computing (Artificial Intelligence)',
}

FactoryGirl.create :course, {
  name: 'MSc in Computing (Computational Management Science)',
}

FactoryGirl.create :course, {
  name: 'MSc in Computing (Distributed Systems)',
}

FactoryGirl.create :course, {
  name: 'MSc in Computing (Machine Learning)',
}

FactoryGirl.create :course, {
  name: 'MSc in Computing (Software Engineering)',
}

FactoryGirl.create :course, {
  name: 'MSc in Computing (Visual Information Processing)',
}

FactoryGirl.create :course, {
  name: 'MRes in Robotics and Image Guided Intervention',
}

Student.all.each do |student|
  student.cv = File.open(File.join(Rails.root, "app", "assets", "files", "cv.pdf" ))
  student.save
end

Company.all.each do |company|

  # Upload Logo
  company.logo = File.open(File.join(Rails.root, "app", "assets", "images", "company_logos", "#{company.name.downcase}_logo.jpg" ))

  # Create events
  5.times do
    e = FactoryGirl.create(:event, :company => company)
  end

  # Create placements
  5.times do
    FactoryGirl.create(:placement, :company => company)
  end

  # Create emails
  # 3.times do
  #   FactoryGirl.create(:tagged_email, :company => company)
  # end

  1.times do
    FactoryGirl.create :company_administrator, {
      email: "#{company.name}@#{company.name}.com".downcase,
      password: "cppcppcpp",
      password_confirmation: "cppcppcpp",
      company: company
    }
  end

  10.times do
    company.company_contacts << (FactoryGirl.create :company_contact, {
      :company => company
    })
  end

  company.save

end

FactoryGirl.create :department_administrator, {
  first_name: "Will",
  last_name: "Knottenbelt",
  email: "doc@doc.com",
  password: "cppcppcpp",
  password_confirmation: "cppcppcpp",
  department: computing_department
}
