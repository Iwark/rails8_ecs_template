# Application Architecture Guidelines

For each major part of the application, always refer to the corresponding guideline document(s) when creating or updating files:

- Controllers (`app/controllers/`): Handle HTTP requests, parameter validation, and delegate business logic.  
  Refer to [controllers.mdc](mdc:.cursor/rules/controllers.mdc) and [test.mdc](mdc:.cursor/rules/test.mdc).

  - API Endpoints (`app/controllers/api/`): Expose endpoints for external and internal clients.  
    Follow RESTful conventions and proper namespacing.  
    Refer to [api.mdc](mdc:.cursor/rules/api.mdc) and [test.mdc](mdc:.cursor/rules/test.mdc).

- Models (`app/models/`): Define domain entities, associations, and validations.  
  Refer to [models.mdc](mdc:.cursor/rules/models.mdc).

- Services (`app/services/`): Encapsulate business logic and domain operations.  
  Refer to [services.mdc](mdc:.cursor/rules/services.mdc) and [test.mdc](mdc:.cursor/rules/test.mdc).

- Forms (`app/forms/`): Handle form objects, validation, and data coercion.  
  Refer to [forms.mdc](mdc:.cursor/rules/forms.mdc) and [test.mdc](mdc:.cursor/rules/test.mdc).

- ViewComponents (`app/frontend/components/`): Implement all UI and view logic using ViewComponents.  
  Place all components in `app/frontend/components/`. Avoid using partials and helpers for presentation logic except in rare, justified cases.  
  Refer to [components.mdc](mdc:.cursor/rules/components.mdc) for best practices and implementation patterns.

- JavaScript (`app/javascript/`): Implement client-side logic and interactivity.  
  For general-purpose JavaScript, use the `app/javascript/` directory.  
  Refer to [javascript.mdc](mdc:.cursor/rules/javascript.mdc).
  For component-specific JavaScript (such as Stimulus controllers), place them as sidecar files within each component directory in `app/frontend/components/`.  
  Refer to [stimulus.mdc](mdc:.cursor/rules/stimulus.mdc).

These guidelines ensure consistency across the codebase and help maintain high-quality standards.

# Product Requirements

Please refer to the PRDs located in the `docs/prds` directory as needed. Additionally, ensure that you update the documentation whenever functionality is added or specifications are changed.

## PRD Directory Structure

All PRDs should follow the directory structure format:

```
docs/prds/{language}/{user_type}/{epic}/{user_story}.md
```

Where:

- `{language}`: Language code (`ja` for Japanese, `en` for English)
- `{user_type}`: Target user type (e.g., `client_admin`, `system_admin`, `client_user`)
- `{epic}`: Epic or feature area (e.g., `user_management`)
- `{user_story}`: Specific feature or user story (e.g., `create_user`)

Example:

```
docs/prds/ja/client_admin/user_management/create_user.md
```

Refer to [prd.mdc](mdc:.cursor/rules/prd.mdc) for the PRD creation guidelines.

# Test-Driven Development (TDD) Principle

- All new features and bug fixes must follow a TDD (Test-Driven Development) approach.
- Always start by writing a failing test that describes the expected behavior or bug.
- Implement the minimum code required to make the test pass.
- Refactor the code while ensuring all tests continue to pass.
- For any code changes, add or update relevant tests in the `spec/` directory.
- Use RSpec for all unit, request, and system tests.
- Ensure all tests pass locally and in CI before merging any changes.
- Test descriptions and documentation must be clear and written in English.

# Code Style

## Ruby Syntax Guidelines

### Hash Value Omission (Ruby 3.1+)

- ALWAYS use hash value omission syntax when the key and value variable have the same name.
- This improves code readability and follows modern Ruby conventions.

### Module and Class Definitions

- Always use nested module/class definitions instead of compact syntax
- Follows RuboCop rule `Style/ClassAndModuleChildren`
- Improves readability and makes namespace structure explicit

## Comments and Documentation

- All comments and documentation within the code must be written in English.
- This includes, but is not limited to, docstrings, inline comments, and explanatory notes.
- Use clear and concise language to ensure that the code is easily understandable by all developers.
- Avoid redundant comments that merely restate what the code does (e.g., `# Create user` for a `create_user` function call).
- Instead, focus comments on explaining:
  - Why a particular implementation approach was chosen
  - Business context and requirements that influenced the code
  - Non-obvious edge cases or workarounds
  - Potential future considerations or technical debt
  - Rationale behind complex algorithms or data structures
  - References to relevant external resources or documentation
- Examples of valuable comments:
  - `# Using raw SQL here for performance reasons as ActiveRecord is too slow for this query`
  - `# Maintaining original implementation for backward compatibility`
  - `# Handling edge case where user might be nil due to race condition`
  - `# TODO: Refactor this after the authentication system update in Q3`
- Comments should add value by providing information that cannot be easily inferred from the code itself.
- For product specifications and requirements:
  - Prefer updating the relevant PRD in the `docs/prds` directory over adding detailed specification comments in code
  - Use code comments to reference the specific PRD when implementing a feature (e.g., `# See docs/prds/meeting_notes.md for detailed requirements`)
  - Keep implementation details in code, but move business rules and specifications to the PRD

# Development Commands

## Rails Runner

For testing and verification without interactive console:

```bash
# Execute Ruby code with Rails environment loaded
docker compose exec web bundle exec rails runner "puts User.count"

# Multi-line code execution
docker compose exec web bundle exec rails runner "
user = User.first
puts user.full_name
"
```

# Git Workflow and Commit Policy

- Do not commit without explicit user instruction:

  - Never stage, commit, amend, or push changes unless the user has clearly asked for it in this conversation.
  - When uncertain, ask for confirmation before creating any commit.

- Never commit to `main`:
  - Do not create commits directly on `main` under any circumstances.
  - Always create a feature branch from the latest `main` and work there.

# Important Rule

## Process for Adding New Rules

When receiving an instruction from a user that seems to require consistent application rather than a one-time response:

1. Ask, "Shall we make this a standard rule?"
2. If a YES answer is obtained, add it as a rule to an appropreate file in `.cursor/rules` directory.
3. Apply it always as a standard rule from then on

This process continuously improves the project's rules.

## ViewComponents Rule

- ViewComponents must not depend on `request` or controller context.
  - Do not reference `request`, `response`, `params`, or `session` inside component classes or templates.
  - Pass all necessary data explicitly via initializer arguments or slots.
  - For behavior differences by context, inject strategy via slots, callables, or explicit flags from the caller.

# Project Setup

- Use Ruby version 3.4.5
- Run commands through Docker:

  ```bash
  # Development commands
  docker compose exec web bundle exec rspec
  docker compose exec web bundle exec rubocop -a

  # Bundle install (required both inside and outside container)
  bundle install
  docker compose exec web bundle install
  ```

- The `web` container has all the necessary development dependencies installed.
- Use the appropriate environment variables and settings as defined in `docker-compose.yml` file.
- Commands should not contain newline characters.

# Lint

- Use RuboCop to enforce consistent code style by running `docker compose exec web bundle exec rubocop -a`
- Follow RuboCop rules specified in `.rubocop.yml`

# Rails Architecture & Design

## Model Layer Responsibilities

- Keep models skinny: focus on data persistence, associations, and simple validations only
- Avoid complex business logic in models: move complex operations to service objects
- Minimize ActiveRecord callbacks for business logic; callbacks should only handle data integrity concerns
- Prevent cross-layer dependencies: models should not directly call service objects

## Service Object Standards

- Use verb-based naming (e.g., `ProcessSesEventService`, `GenerateInvoiceService`)
- Single public method: `call`
- Clear constructor: accept all required parameters in `initialize`
- Standard interface pattern:

  ```ruby
  # Good
  ProcessDataService.new(data, options).call

  # Avoid
  ProcessDataService.new(data).process_with_options(options)
  ```

## Controller Organization

- Follow Rails namespace conventions
  - Base controllers: `app/controllers/namespace/application_controller.rb`
  - Inherited controllers: `app/controllers/namespace/specific_controller.rb`
  - Example: `Webhooks::ApplicationController`, `Api::ApplicationController`
- Namespace module structure:

  ```ruby
  module Webhooks
    class ApplicationController < ActionController::Base
      # Common webhook functionality
    end

    class SesWebhookController < ApplicationController
      # SES-specific webhook handling
    end
  end
  ```

# Routing

- Routes are defined in `config/routes.rb`
- API endpoints are namespaced under `/api`:
  - `/api/v1/`: External API for native applications (Mac OS, Windows, iOS, Android)
  - `/api/web/`: Internal API for Rails frontend JavaScript
- Follow RESTful conventions for resource naming and actions
- When defining new routes:
  - Use proper namespacing for controllers
  - Use proper module and route name prefixing (e.g., `scope module: :admin, as: :admin`)
  - Prefer resourceful routes over custom routes when possible
- Add necessary access constraints for sensitive endpoints (`constraints CanAccessSidekiqDashboard`)

# Testing

## Parallel Tests

- Use `parallel_tests` gem to run tests across multiple CPU cores

## Test Commands

```bash
# Prepare for testing (setup databases) and run parallel tests (faster, recommended for full test suite)
docker compose exec web bundle exec rails parallel:spec_full

# Run specific test file - keep it simple
docker compose exec web bundle exec rspec spec/path/to/test_file_spec.rb
```

## Individual File Testing

- Keep RSpec commands simple for specific files
- Avoid complex flags unless explicitly requested
- Minimal syntax: `docker compose exec web bundle exec rspec [file_path]`
