# app/services/api_data_service.rb
require "http"

class PropertyGetbuilt
  BASE_URL = "https://api.getbuilt.com/financial-relationships-product-api/graphql"

  def self.fetch_and_store
    auth_token = Rails.application.credentials.dig(:api, :auth_token)

    payload = { "operationName": "GetLoan", "variables": { "loanId": 2430264 }, "query": "query GetLoan($loanId: Int!) {\n  loan(loanId: $loanId) {\n    ...LoanFields\n    __typename\n  }\n}\n\nfragment LoanFields on Loan {\n  agreementUid\n  agreementType\n  bankId\n  borrowerId\n  expectedConstructionEndDate\n  userIsBorrowerForLoan\n  branch {\n    address {\n      address1\n      address2\n      city\n      state\n      zip\n      __typename\n    }\n    bank {\n      name\n      __typename\n    }\n    branchId\n    branchNumber\n    branchUid\n    description\n    formattedAddress\n    __typename\n  }\n  borrower {\n    builderId\n    builderUid\n    formattedAddress\n    name\n    primaryAdministrator {\n      email\n      fullName\n      __typename\n    }\n    primaryPhoneNumber {\n      number\n      __typename\n    }\n    __typename\n  }\n  builderAccessLevel\n  userAccessLevel\n  builder {\n    name\n    builderId\n    primaryAdministrator {\n      email\n      fullName\n      __typename\n    }\n    primaryPhoneNumber {\n      number\n      __typename\n    }\n    __typename\n  }\n  comments {\n    ...loanDrawComment\n    __typename\n  }\n  commercial {\n    financials {\n      inspectionFee\n      __typename\n    }\n    __typename\n  }\n  constructionProgress\n  financials {\n    ...LoanFinancials\n    __typename\n  }\n  formattedAddress\n  formattedLoanType\n  inspector {\n    inspectorId\n    primaryAdministrator {\n      email\n      fullName\n      __typename\n    }\n    primaryInspectorPhoneNumberId\n    __typename\n  }\n  lenderBrandedDisplayName\n  loanAdministrator {\n    email\n    firstName\n    lastName\n    fullName\n    primaryPhoneNumber {\n      number\n      __typename\n    }\n    __typename\n  }\n  loanBudgetId\n  loanId\n  loanNumber\n  loanSettings {\n    allowDrawRequestOverfundRemaining\n    canBorrowerEditBudgetReallocations\n    isItemizedDraw\n    lenderControlledInspections\n    __typename\n  }\n  loanBadgeType\n  loanType\n  location {\n    ...LoanLocation\n    __typename\n  }\n  relationshipManagerId\n  nextInspectionDate\n  inspectionSettings {\n    reducedAvailableToDrawMessagingBuilderBorrowers\n    inspectionFrequency\n    inspectionInterval {\n      label\n      __typename\n    }\n    isItemizedDraw\n    isAutodraw\n    __typename\n  }\n  parentLoanId\n  status {\n    text\n    status\n    __typename\n  }\n  residential {\n    inspectionSettings {\n      allowMultipleDraws\n      drawsRequestReserveAndFees\n      isAutoinspect\n      isBorrowerManagedReallocations\n      __typename\n    }\n    financials {\n      includedInspections\n      inspectionFee\n      typeLabel\n      __typename\n    }\n    property {\n      bathrooms\n      bedrooms\n      blockNumber\n      buildingPermitIssueDate\n      buildingPermitNumber\n      description\n      exterior\n      foundation\n      garageSize\n      garageSizeMeters\n      lockbox\n      phaseNumber\n      propertyId\n      propertyType\n      squareFeet\n      squareMeters\n      stories\n      __typename\n    }\n    __typename\n  }\n  userIsBorrowerForLoan\n  __typename\n}\n\nfragment loanDrawComment on Comment {\n  contextId\n  content\n  createdAt\n  __typename\n}\n\nfragment LoanFinancials on Financials {\n  amount\n  amountAvailableForConstruction\n  appraisalDate\n  appraisalReviewAmount\n  appraisalReviewValue\n  appraisedValue\n  availableToDraw\n  balanceRemaining\n  caseNumber\n  constructionAmount\n  constructionProgressFunded\n  constructionStartDate\n  costCenter\n  ddaNumber\n  defaultRetainageAccountId\n  drawnToDate\n  equityAmount\n  equityFundedAmount\n  equityRemaining\n  fundedAmount\n  generalLedgerAccountNumber\n  hardCostAvailableToDraw\n  hardCostDrawnToDate\n  inspectionFee\n  loanAmount\n  loanBalanceRemaining\n  loanClosedDate\n  loanFinancialId\n  loanFundedAmount\n  loanMaturityDate\n  loanNumber\n  loanToCost\n  loanToValue\n  maturity\n  originalLoanToCost\n  originalLoanToValue\n  principalBalance\n  projectAmount\n  projectBalanceRemaining\n  releasedFunds\n  retainageAmount\n  retainagePercentage\n  revisedAvailableForConstruction\n  revisedLoanAmount\n  __typename\n}\n\nfragment LoanLocation on Location {\n  addressId\n  address {\n    address1\n    address2\n    city\n    county\n    countryCode\n    state\n    zip\n    __typename\n  }\n  latitude\n  longitude\n  lotNumber\n  subdivision {\n    city\n    county\n    description\n    name\n    state\n    zip\n    __typename\n  }\n  __typename\n}" }


    # Make the API request
    response = HTTP.auth("Bearer #{auth_token}")
                   .post(BASE_URL, json: payload) # Replace with your specific endpoint

    if response.status.success?
      # Parse the API response
      json_data = response.parse
      loan_data = json_data.dig("data", "loan") # Access the loan data within the response
      loan_number = loan_data["loanNumber"] # Extract the loanNumber from the response

      if loan_number.present?
        # Ensure uniqueness when saving
        existing_record = GetbuiltProperty.find_by(account: loan_number)

        if existing_record
          # Update the record if the loanNumber already exists
          existing_record.update(data: loan_data)
        else
          # Create a new record with the loanNumber in the account field
          GetbuiltProperty.create!(account: loan_number, data: loan_data)
        end
      else
        Rails.logger.error("Loan number not found in the API response")
        raise "Loan number not found in the API response"
      end
    else
      Rails.logger.error("API Request failed: #{response.status}")
      raise "API Request failed: #{response.status}"
    end
  end
end
