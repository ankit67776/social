  class MaturityReminderJob < ApplicationJob
    queue_as :default

    def perform
      recipients = [ "saxena.anshul@gmail.com", "ankitsinghraikwal@gmail.com" ]
      properties = GetbuiltProperty.all

      properties.each do |property|
        loan_data = property.data
        maturity_date = loan_data.dig("financials", "loanMaturityDate")

        if maturity_date && Date.parse(maturity_date) <= Date.today + 200.days
          # Send email notification to all recipients
          recipients.each do |email|
            LoanMailer.maturity_reminder(
              loan_number: loan_data["loanNumber"],
              maturity_date: maturity_date,
              email: email
            ).deliver_now
          end

          # Log the reminder in the Rails log
          Rails.logger.info("Reminder sent: Loan #{loan_data['loanNumber']} is maturing on #{maturity_date}.")
        end
      end
    end
  end
