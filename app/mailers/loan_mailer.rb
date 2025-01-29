class LoanMailer < ApplicationMailer
  default from: "firsttrillionaire01@gmail.com"

  def maturity_reminder(loan_number:, maturity_date:, email:)
    @loan_number = loan_number
    @maturity_date = maturity_date

    mail(
      to: email,
      subject: "Reminder: Loan #{@loan_number} is maturing soon"
    )
  end
end
