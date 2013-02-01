
###
Controller
###
app.controller "Ctrl", ($scope) ->

  $scope.calculatePaymentAmountPerPeriod = ->
    P = $scope.var.initialPrinciple
    n = $scope.var.termInYears * 12
    r = $scope.var.annualIntrestRate / 100 / 12
    A = P * (r * Math.pow(1 + r, n)) / (Math.pow(1 + r, n) - 1)
    A = Math.ceil(A * 100) / 100

    $scope.var.paymentAmountPerPeriod = A
    $scope.var.data = []
    return


  $scope.generateAmortizationSchedule = ->
    $scope.var.isGeneratingSchedule = true
    $scope.var.data = []

    P = $scope.var.initialPrinciple
    n = $scope.var.termInYears * 12
    r = $scope.var.annualIntrestRate / 100 / 12
    A = $scope.var.paymentAmountPerPeriod
    payPeriod         = 1
    totalCost         = 0 # total mortgage cost
    remainingBalance  = P
    paydownStart      = parseFloat $scope.var.paydownStart
    data = []
    yearEntry = { year: 0 }

    getYearViaPayPeriod = (payPeriod) -> 
      return Math.floor ( payPeriod - 1 ) / 12 + 1

    roundUp = (amount) ->
      return Math.round( amount * 100 ) / 100


    while remainingBalance > 0

      year = getYearViaPayPeriod(payPeriod)

      paydown = if ( paydownStart <= year ) then $scope.var.paydown else 0
      payoff =            roundUp remainingBalance + remainingBalance * r
      payment =           roundUp Math.min(payoff, A + paydown)
      interestPaid =      roundUp P * r
      principlePaid =     roundUp payment - interestPaid
      remainingBalance =  roundUp remainingBalance - principlePaid
      totalCost =         roundUp totalCost + payment


      # Create new entry if new year
      unless yearEntry.year == year
        yearEntry = {
          year: year
          entries: []
        }

      # add entry to yearEntry
      yearEntry.entries.push {
        payPeriod:        payPeriod
        payment:          payment
        interestPaid:     interestPaid
        principlePaid:    principlePaid
        remainingBalance: remainingBalance
        totalCost:        totalCost
      }

      # if finished with year or finshed paying off, add yearEntry to data
      if (payPeriod % 12 == 0) || remainingBalance == 0
        data.push yearEntry

      payPeriod++
      P = P - roundUp principlePaid

    $scope.var.isGeneratingSchedule = false
    $scope.var.data = data
    return    

  $scope.sumPaymentAndPaydown = ->
    paydown = parseFloat $scope.var.paydown
    return paydown + $scope.var.paymentAmountPerPeriod

  $scope.initializeModel = ->
    $scope.var = {}
    $scope.var.data = []
    $scope.var.initialPrinciple = 300000
    $scope.var.annualIntrestRate = 5.875
    $scope.var.termInYears = 30
    $scope.var.paydown = 0
    $scope.var.paydownStart = 0
    $scope.calculatePaymentAmountPerPeriod()


  $scope.initializeModel()
  return


