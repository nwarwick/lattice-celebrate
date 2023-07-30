require "minitest/autorun"
require_relative "../lambda_function"

class TestLambdaFunction < Minitest::Test
  def test_generate_message
    team = ["Nicholas", "Kiril", "Johnny", "Lucas", "Martin L", "Martin G", "Levi", "Nachiket"]
    assert_equal "Happy workaversary Nicholas! \u{1F389}", generate_message("workaversary", ["Nicholas"])
    assert_equal "Happy workaversary to Nicholas, Kiril, Johnny, Lucas, Martin L, Martin G, Levi and Nachiket! \u{1F389}",
      generate_message("workaversary", team)
    assert_equal "Happy workaversary to Nicholas and Kiril! \u{1F389}", generate_message("workaversary", team[0..1])
  end

  def test_remove_ignored_users
    @employees = [
      {"name" => "Nachiket", "email" => "nachiket@example.com"},
      {"name" => "Levi", "email" => "levi@example.com"},
      {"name" => "Martin", "email" => "martin@example.com"}
    ]

    ENV["IGNORED_USERS"] = "levi@example.com, martin@example.com"
    assert_equal [{"name" => "Nachiket", "email" => "nachiket@example.com"}],
      remove_ignored_users
  end
end
