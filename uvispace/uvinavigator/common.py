# ugv types
class ControllerType():
    neural_line_follower = "neural_line_follower"
    tables_line_follower = "tables_line_follower"
    fuzzy_point_to_point = "fuzzy_point_to_point"

class TableAgentType():
     sarsa = "SARSA"
     qlearning = "Q-Learning"
     expected_sarsa = "Expected SARSA"
     nstep_sarsa = "n-step SARSA"
