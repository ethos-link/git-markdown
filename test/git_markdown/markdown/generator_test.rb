# frozen_string_literal: true

require "test_helper"

class GeneratorTest < Minitest::Test
  def setup
    @pr = GitMarkdown::Models::PullRequest.new(
      number: 123,
      title: "Test PR Title",
      body: "This is the PR description",
      state: "open",
      author: "testuser",
      html_url: "https://github.com/owner/repo/pull/123",
      created_at: "2024-01-15T10:00:00Z"
    )

    @comments = [
      GitMarkdown::Models::Comment.new(
        id: 1,
        body: "Great work!",
        author: "reviewer1",
        created_at: "2024-01-15T11:00:00Z"
      )
    ]

    @reviews = [
      GitMarkdown::Models::Review.new(
        id: 1,
        state: "APPROVED",
        body: "LGTM",
        author: "reviewer2",
        submitted_at: "2024-01-15T12:00:00Z",
        comments: [
          GitMarkdown::Models::Comment.new(
            id: 2,
            body: "Consider using better variable names",
            author: "reviewer2",
            path: "app/models/user.rb",
            line: 15,
            created_at: "2024-01-15T12:00:00Z"
          )
        ]
      )
    ]
  end

  def test_generates_markdown
    generator = GitMarkdown::Markdown::Generator.new(@pr, @comments, @reviews)
    markdown = generator.generate

    assert_includes markdown, "# Test PR Title"
    assert_includes markdown, "**#123** by @testuser"
    assert_includes markdown, "This is the PR description"
    assert_includes markdown, "Great work!"
    assert_includes markdown, "app/models/user.rb"
  end

  def test_generates_filename
    generator = GitMarkdown::Markdown::Generator.new(@pr, @comments, @reviews)

    assert_equal "PR-123-test-pr-title.md", generator.filename
  end

  def test_filters_unresolved_comments_by_default
    resolved_comment = GitMarkdown::Models::Comment.new(
      id: 3,
      body: "[resolved] This is done",
      author: "reviewer3",
      created_at: "2024-01-15T13:00:00Z"
    )

    generator = GitMarkdown::Markdown::Generator.new(
      @pr,
      @comments + [resolved_comment],
      @reviews
    )

    markdown = generator.generate
    assert_includes markdown, "Great work!"
    refute_includes markdown, "[resolved] This is done"
  end

  def test_includes_resolved_when_filtered
    resolved_comment = GitMarkdown::Models::Comment.new(
      id: 3,
      body: "[resolved] This is done",
      author: "reviewer3",
      created_at: "2024-01-15T13:00:00Z"
    )

    generator = GitMarkdown::Markdown::Generator.new(
      @pr,
      @comments + [resolved_comment],
      @reviews,
      status_filter: :all
    )

    markdown = generator.generate
    assert_includes markdown, "Great work!"
    assert_includes markdown, "[resolved] This is done"
  end

  def test_sluggifies_title_for_filename
    pr = GitMarkdown::Models::PullRequest.new(
      number: 456,
      title: "Fix: Handle user's special & weird $characters!",
      state: "open",
      author: "testuser"
    )

    generator = GitMarkdown::Markdown::Generator.new(pr, [], [])

    assert_equal "PR-456-fix-handle-user-s-special-weird-characters.md", generator.filename
  end
end
