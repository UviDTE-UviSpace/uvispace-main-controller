import unittest
import numpy.testing as npt
from uvispace.uvirobot.speedtransform import Speed


class MySetSpeedTestCases(unittest.TestCase):
    """Tests the initialization and different set_speed situations."""

    def test_init(self):
        """Speed() __init__ method: Tests no argument initialization."""
        my_speed = Speed()
        npt.assert_equal(my_speed._speed, [0, 0])
        self.assertEqual(my_speed._format, 'linear_angular')
        self.assertEqual(my_speed._scale, 'linear')
        self.assertEqual(my_speed._min_value, -0.3)
        self.assertEqual(my_speed._max_value, 0.3)

    def test_set_speed_in_bounds(self):
        """Speed() set_speed method: Checks speed set inside limits."""
        my_speed = Speed()
        max_allowed = my_speed.get_max_value()
        min_allowed = my_speed.get_min_value()
        speed_a = max_allowed / 2.0
        speed_b = min_allowed / 2.0
        my_speed.set_speed([speed_a, speed_b], 'linear_angular')
        npt.assert_equal(my_speed.get_speed(), [speed_a, speed_b])

    def test_set_speed_respect_limits(self):
        """Speed() set_speed method: Checks limits are not surpassed."""
        my_speed = Speed()
        max_allowed = my_speed.get_max_value()
        min_allowed = my_speed.get_min_value()
        speed_a = max_allowed + 1
        speed_b = min_allowed - 1
        my_speed.set_speed([speed_a, speed_b], 'linear_angular')
        npt.assert_equal(my_speed.get_speed(), [max_allowed, min_allowed])
        # Tests the error raising when a wrong speed value is passed
        with self.assertRaises(ValueError):
            my_speed.set_speed(['a', 0], 'linear_angular')
        with self.assertRaises(ValueError):
            my_speed.set_speed([1, 1, 1], 'linear_angular')
        with self.assertRaises(ValueError):
            my_speed.set_speed([], 'linear_angular')
        with self.assertRaises(ValueError):
            my_speed.set_speed([[1, 1]], 'linear_angular')

    def test_set_speed_format_scale_change(self):
        """Speed() set_speed method: Checks scale and format change."""
        my_speed = Speed()
        my_speed.set_speed([0, 0], '2_wheel_drive', 'non-linear')
        self.assertEqual(my_speed._format, '2_wheel_drive')
        self.assertEqual(my_speed._scale, 'non-linear')
        with self.assertRaises(ValueError):
            my_speed.set_speed([0, 0], speed_format='wrong format')
        with self.assertRaises(ValueError):
            my_speed.set_speed([0, 0], '2_wheel_drive',
                               speed_scale='wrong scale')


class MyNonLinearTransformTestCases(unittest.TestCase):
    """Tests the nonlinear_transform method."""

    def test_nonlinear_transform_zero(self):
        """Speed() nonlinear_transform method: Checks 0 conversion."""
        my_speed = Speed()
        my_speed.set_speed([0, 0], 'linear_angular')
        my_speed.nonlinear_transform(min_A=30, max_A=100,
                                     min_B=160, max_B=220,
                                     scale_zero=127)
        npt.assert_equal(my_speed._speed, [127, 127])

    def test_nonlinear_transform_limits(self):
        """Speed() nonlinear_transform method: Checks scale limits."""
        # Checks the maximum and minimum limits.
        my_speed = Speed()
        max_allowed = my_speed.get_max_value()
        min_allowed = my_speed.get_min_value()
        my_speed.set_speed([max_allowed, min_allowed], 'linear_angular')
        my_speed.nonlinear_transform(min_A=30, max_A=100,
                                     min_B=160, max_B=220,
                                     scale_zero=127)
        npt.assert_equal(my_speed._speed, [220, 30])
        # Checks for values very near to 0.
        my_speed = Speed()
        my_speed.set_speed([0.0000001, -0.0000001], 'linear_angular')
        my_speed.nonlinear_transform(min_A=30, max_A=100,
                                     min_B=160, max_B=220,
                                     scale_zero=127)
        npt.assert_allclose(my_speed._speed, [160.0, 100.0], atol=1)

    def test_nonlinear_transform_limits_error(self):
        """Speed() nonlinear_transform method: Checks error raising."""
        my_speed = Speed()
        my_speed.set_speed([0, 0], 'linear_angular')
        # Segment A minimum greater than its maximum.
        with self.assertRaises(ValueError):
            my_speed.nonlinear_transform(min_A=120, max_A=100,
                                         min_B=160, max_B=220)
        # Segment A maximum equal to zero value.
        with self.assertRaises(ValueError):
            my_speed.nonlinear_transform(min_A=30, max_A=127,
                                         min_B=160, max_B=220,
                                         scale_zero=127)
        # Segment B minimum equal to zero value.
        with self.assertRaises(ValueError):
            my_speed.nonlinear_transform(min_A=30, max_A=100,
                                         min_B=127, max_B=220,
                                         scale_zero=127)
        # It is passed a string to one argument.
        with self.assertRaises(ValueError):
            my_speed.nonlinear_transform(min_A=30, max_A=100,
                                         min_B=160, max_B='a',
                                         scale_zero=127)
        # It is passed an empty tuple to one argument.
        with self.assertRaises(TypeError):
            my_speed.nonlinear_transform(min_A=[], max_A=100,
                                         min_B=160, max_B=220,
                                         scale_zero=127)


class Get2WDSpeedsTestCases(unittest.TestCase):
    """Tests the get_2WD_speeds method."""

    def test_get_2wd_speeds(self):
        """Speed() get_2WD_speeds method: Checks max lineal."""
        my_speed = Speed()
        max_allowed = my_speed.get_max_value()
        min_allowed = my_speed.get_min_value()
        # First case. lineal max speed, no angular speed
        my_speed.set_speed([max_allowed, 0.0], 'linear_angular')
        my_speed.get_2WD_speeds(rho=0.065, L=0.150)
        # 4.615 = 0.3 / 0.065
        npt.assert_allclose(my_speed._speed, [4.615, 4.615], atol=0.001)
        # New case. lineal reverse max speed, no angular speed
        my_speed = Speed()
        my_speed.set_speed([min_allowed, 0.0], 'linear_angular')
        my_speed.get_2WD_speeds(rho=0.065, L=0.150)
        npt.assert_allclose(my_speed._speed, [-4.615, -4.615], atol=0.001)

    def test_wheel_coeficients(self):
        """Speed() get_2WD_speeds method: Checks wheel coeficients."""
        my_speed = Speed()
        max_allowed = my_speed.get_max_value()
        min_allowed = my_speed.get_min_value()
        # First case, positive values
        my_speed.set_speed([max_allowed, 0], 'linear_angular')
        my_speed.get_2WD_speeds(rho=0.065, L=0.150, wheels_modifiers=[1, 0.5])
        # 4.615 = max_allowed / rho = 0.3 / 0.065
        # 2.308 = 4.615 * 0.5
        npt.assert_allclose(my_speed._speed, [4.615, 2.308], atol=0.001)
        # Second case, negative values
        my_speed.set_speed([min_allowed, 0], 'linear_angular')
        my_speed.get_2WD_speeds(rho=0.065, L=0.150, wheels_modifiers=[0.5, 1])
        # 4.615 = max_allowed / rho = 0.3 / 0.065
        # 2.308 = 4.615 * 0.5
        npt.assert_allclose(my_speed._speed, [-2.308, -4.615], atol=0.001)
