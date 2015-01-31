FactoryGirl.define do
  factory :organisation do
    name "Imperial College London"

    factory :organisation_with_domains do
      after(:build) do |org|
        ["imperial.ac.uk", "ic.ac.uk"].each do |domain|
          org.organisation_domains << FactoryGirl.build(:organisation_domain,
                                        :organisation => org,
                                        :domain => domain)
        end
      end
    end
  end
end
