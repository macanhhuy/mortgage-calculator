
###
Controller
###
app.controller "Ctrl", ($scope) ->
  $scope.calculatePaymentAmountPerPeriod = ->
    P = $scope.initialPrinciple.handle1
    n = $scope.termInYears.handle1 * 12
    r = $scope.annualIntrestRate.handle1 / 100 / 12
    if r == 0 
      A = P / n;
    else 
      A = P * (r * Math.pow(1 + r, n)) / (Math.pow(1 + r, n) - 1)


    A = Math.ceil(A * 100) / 100

    $scope.paymentAmountPerPeriod = A
    $scope.data = []
    return


  $scope.generateAmortizationSchedule = ->
    $scope.var.isGeneratingSchedule = true
    $scope.data = []

    P = $scope.initialPrinciple.handle1
    n = $scope.termInYears.handle1 * 12
    r = $scope.annualIntrestRate.handle1 / 100 / 12
    A = $scope.paymentAmountPerPeriod
    paydownAmount     = $scope.paydown.handle1
    payPeriod         = 1
    totalCost         = 0 # total mortgage cost
    remainingBalance  = P
    paydownStart      = parseFloat $scope.paydownStart.handle1
    data = []
    yearEntry = { year: 0 }

    getYearViaPayPeriod = (payPeriod) -> 
      return Math.floor ( payPeriod - 1 ) / 12 + 1

    roundUp = (amount) ->
      return Math.round( amount * 100 ) / 100


    while remainingBalance > 0

      year = getYearViaPayPeriod(payPeriod)

      paydown = if ( paydownStart <= year ) then paydownAmount else 0
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

    $scope.isGeneratingSchedule = false
    $scope.data = data
    return    

  $scope.sumPaymentAndPaydown = ->
    paydown = parseFloat $scope.paydown.handle1
    return paydown + $scope.paymentAmountPerPeriod

  $scope.initializeModel = ->
    $scope.var = {}
    $scope.var.data = []

    $scope.initialPrinciple = {
      min: 0,
      max: 1500000,
      step: 10000,
      handle1: 500000
    };

    $scope.annualIntrestRate = {
      min: 0.0,
      max: 10.0,
      step: 0.025,
      handle1: 4.0
    };

    $scope.termInYears = {
      min: 1,
      max: 40,
      step: 1,
      handle1: 30
    };

    $scope.paydown = {
      min: 0,
      max: 5000,
      step: 50,
      handle1: 0
    };

    $scope.paydownStart = {
      min: 0,
      max: 30,
      step: 1,
      handle1: 0
    };

    $scope.calculatePaymentAmountPerPeriod()


  $scope.$watch('initialPrinciple.handle1 + annualIntrestRate.handle1 + termInYears.handle1 + paydown.handle1 + paydownStart.handle1', ->
    $scope.calculatePaymentAmountPerPeriod()
  )

  $scope.initializeModel()
  return


