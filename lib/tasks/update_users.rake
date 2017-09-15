

desc "TODO"
task :update_users => :environment do

  users = User.all

  users.each do |user|
    if Time.now >= user.next_billing_date
      # Updating the next billing date by a month
      user.next_billing_date += 1.month

      # update monthly reviews by subscription type
      if user.subscription = 'trial'
        user.video_reviews = 2
      else
        user.video_reviews = 4
      end

      user.save
    end
  end
end
