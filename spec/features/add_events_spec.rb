require 'spec_helper'

feature "Manage events" do
    subject {FactoryGirl.create(:registered_user)}
    let(:team) {FactoryGirl.create(:team)}
    before(:each) do
      FactoryGirl.create(:event)
    end

    scenario "User can register for a new event" do
        subject.teams << team
        subject.teams.count.should eq 1
        sign_in_with(subject.email, subject.password)
        expect(current_path).to eq("/")
        click_link("Tour Events")
        expect{
            expect(page).to have_content("Chippawa, Upper Niagara")
            click_button("Details")
            click_button("Yes")
            expect(page).to have_content("Your team is now registered to participate in #{Event.first.name}")
            }.to change{subject.teams.first.events.count}.from(0).to(1)
    end

    scenario "User should not be able to register for an event with out a team" do
        subject.teams.count.should eq 0
        sign_in_with(subject.email, subject.password)
        expect(current_path).to eq('/')
        click_link "Tour Events"
        expect(page).to have_content("Chippawa, Upper Niagara")
        click_button("Details")
        expect(page).to have_content("You Must Find a Teammate in Order to Register this Event")
    end

    scenario "User should not be allowed to register an event they are already registered for" do
        subject.teams << team
        subject.teams.count.should eq 1
        sign_in_with(subject.email, subject.password)
        click_link("Tour Events")
        expect{
            expect(page).to have_content("Chippawa, Upper Niagara")
            click_button("Details")
            click_button("Yes") # add the event once
            click_button("Yes") # attempt to add the event again
            click_button("Yes") # But should not work
            }.to change{subject.teams.first.events.count}.by(1)
    end

end