require 'spec_helper'
# in need of major refactor
feature "Teammate Request" do
        subject(:requester) { FactoryGirl.create(:profile).user }
        let(:requestee) { FactoryGirl.build(:unregisterd_user) }

    context "User sends team request" do
        scenario "to unregistered user" do

            sign_in_with(requester.email, requester.password)
            page.current_path.should eq '/'
            page.should have_content('What\'s next? Find a teammate so you two
                can join some tournaments!')
            click_link "Grab A Teammate"

            send_team_request "Don", "Stevies", requestee.email

            page.current_path.should eq '/teammate/search'
            page.should have_content("No such email in our database. Send them an invite.")
            expect{click_link "Invite Don"}.to change{Request.count}.from(0).to(1)
            last_email.to.should include requestee.email
            last_email.subject.should have_content("#{requester.full_name}
                wants to go fishing!")

            page.current_path.should eq '/'
            page.should have_content("Your request has been sent to your
                teammate. If Don Stevies accepts, you may enter a
                tournament.")

            last_email.body.should have_content("#{requester.profile.first_name}
                #{requester.profile.last_name} wants you on his team")
        end
    end

    context "Receiving teammate request" do
        let(:request) { FactoryGirl.create(:request, requester: requester.id)}
        context "accept teammate invite" do
            scenario "as an unregistered user" do
                visit request.acceptance_url
                page.current_path.should eq '/users/sign_up'
                # register and confirm
                sign_up_with(requestee.email, requestee.password)
                page.current_path.should eq '/thanks'
                expect(page).to have_content("You have 1 team invite pending")
                click_link "View Invites"

            end
        end
    end

end