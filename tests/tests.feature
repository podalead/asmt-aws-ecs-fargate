Scenario Outline: MyNetwork
  Given I have network module configured
  Then it must contain (vpc_id subnet_cidr)