# Changes the model schema
# Used for events and placements when a department is creating an event
# Will give department option to select company rather than the schema of
# the model which originally exists with a department schema
window.swapDepartmentToCompanySchema = (model, department) ->
    schema = model.schema()

    if model.isNew()
      schema['company_id'] = {
        title: "Company*"
        type: "Select"
        template: "field"
        options: department.companies
        editorClass: "company-select"
      }
      
      model.set 'departments', [department.id]

    delete schema["departments"]
    model.schema = -> schema

# To be used with backbone forms as so:
# validateField(@form, field) for field of @form.fields
window.validateField = (form, field) ->
    form.on "#{field}:change", (form, fieldEditor) =>
      form.fields[field].clearError()
      if form.fields[field].validators
        form.fields[field].validate()

      errors = form.model.preValidate(field, form.fields[field].getValue())
      if (errors)
        form.fields[field].setError(errors)

# Returns if a user (student) is planning to attend an event
window.studentAttendEvent = (event) ->
  isStudent() && event.registered_students.get(userId()) != undefined

# Looking for status options for students
window.looking_fors = {
  summer: "Summer Placement"
  industrial: "Industrial Placement"
  graduate: "Graduate Job"
  nothing: "Not looking for anything"
  graduateSecured: "Secured graduate position"
  summerSecured: "Secured summer internship"
  industrialSecured: "Secured industrial placement"
}

window.addPlacementTableRow = (placement, attr, label) ->
  val = placement.get attr
  if val then "<tr><td>#{label}:</td><td>#{val}</td></tr>" else ''


#Sector options for companies
window.sectors = ['Accounting',
'Airlines/Aviation',
'Alternative Dispute Resolution',
'Alternative Medicine',
'Animation',
'Apparel & Fashion',
'Architecture & Planning',
'Arts and Crafts',
'Automotive',
'Aviation & Aerospace',
'Banking',
'Biotechnology',
'Broadcast Media',
'Building Materials',
'Business Supplies and Equipment',
'Capital Markets',
'Chemicals',
'Civic & Social Organization',
'Civil Engineering',
'Commercial Real Estate',
'Computer & Network Security',
'Computer Games',
'Computer Hardware',
'Computer Networking',
'Computer Software',
'Construction',
'Consumer Electronics',
'Consumer Goods',
'Consumer Services',
'Cosmetics',
'Dairy',
'Defense & Space',
'Design',
'Education Management',
'E-Learning',
'Electrical/Electronic Manufacturing',
'Entertainment',
'Environmental Services',
'Events Services',
'Executive Office',
'Facilities Services',
'Farming',
'Financial Services',
'Fine Art',
'Fishery',
'Food & Beverages',
'Food Production',
'Fund-Raising',
'Furniture',
'Gambling & Casinos',
'Glass, Ceramics & Concrete',
'Government Administration',
'Government Relations',
'Graphic Design',
'Health, Wellness and Fitness',
'Higher Education',
'Hospital & Health Care',
'Hospitality',
'Human Resources',
'Import and Export',
'Individual & Family Services',
'Industrial Automation',
'Information Services',
'Information Technology and Services',
'Insurance',
'International Affairs',
'International Trade and Development',
'Internet',
'Investment Banking',
'Investment Management',
'Judiciary',
'Law Enforcement',
'Law Practice',
'Legal Services',
'Legislative Office',
'Leisure, Travel & Tourism',
'Libraries',
'Logistics and Supply Chain',
'Luxury Goods & Jewelry',
'Machinery',
'Management Consulting',
'Maritime',
'Marketing and Advertising',
'Market Research',
'Mechanical or Industrial Engineering',
'Media Production',
'Medical Devices',
'Medical Practice',
'Mental Health Care',
'Military',
'Mining & Metals',
'Motion Pictures and Film',
'Museums and Institutions',
'Music',
'Nanotechnology',
'Newspapers',
'Nonprofit Organization Management',
'Oil & Energy',
'Online Media',
'Outsourcing/Offshoring',
'Package/Freight Delivery',
'Packaging and Containers',
'Paper & Forest Products',
'Performing Arts',
'Pharmaceuticals',
'Philanthropy',
'Photography',
'Plastics',
'Political Organization',
'Primary/Secondary Education',
'Printing',
'Professional Training & Coaching',
'Program Development',
'Public Policy',
'Public Relations and Communications',
'Public Safety',
'Publishing',
'Railroad Manufacture',
'Ranching',
'Real Estate',
'Recreational Facilities and Services',
'Religious Institutions',
'Renewables & Environment',
'Research',
'Restaurants',
'Retail',
'Security and Investigations',
'Semiconductors',
'Shipbuilding',
'Sporting Goods',
'Sports',
'Staffing and Recruiting',
'Supermarkets',
'Telecommunications',
'Textiles',
'Think Tanks',
'Tobacco',
'Translation and Localization',
'Transportation/Trucking/Railroad',
'Utilities',
'Venture Capital & Private Equity',
'Veterinary',
'Warehousing',
'Wholesale',
'Wine and Spirits',
'Wireless',
'Writing and Editing']