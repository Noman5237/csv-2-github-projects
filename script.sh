set -e

# CSV file path
CSV_FILE=$1

# GitHub project info
OWNER=$2
PROJECT_NUMBER=$3

# Get project ID
project_id=$(gh project view "$PROJECT_NUMBER" --owner "$OWNER" --format json | jq -r '.id')

# Get all fields in the project
FIELDS_JSON=$(gh project field-list "$PROJECT_NUMBER" --owner "$OWNER" --format json)

# Dynamically get field IDs
get_field_id() {
  echo "$FIELDS_JSON" | jq -r --arg name "$1" '.fields[] | select(.name == $name) | .id'
}

epic_field_id=$(get_field_id "Epic")
feature_field_id=$(get_field_id "Feature")
role_field_id=$(get_field_id "Role")
estimate_field_id=$(get_field_id "Estimate")

echo "Project ID:         $project_id"
echo "Epic Field ID:	  $epic_field_id"
echo "Feature Field ID:   $feature_field_id"
echo "Role Field ID:      $role_field_id"
echo "Estimate Field ID:  $estimate_field_id"
echo

# Skip header and loop over CSV
tail -n +2 "$CSV_FILE" | while IFS=',' read -r module feature task role hours; do
  module=$(echo "$module" | xargs)
  feature=$(echo "$feature" | xargs)
  task=$(echo "$task" | xargs)
  role=$(echo "$role" | xargs)
  hours=$(echo "$hours" | tr -d '\r' | xargs)

  echo "📦 Creating item: $module:$feature:$task:$role:$hours"

  # Create draft item
  item_id=$(gh project item-create "$PROJECT_NUMBER" --owner "$OWNER" --title "$task" --format json | jq -r '.id')

  # Set Epic
  gh project item-edit \
    --id "$item_id" \
    --project-id "$project_id" \
    --field-id "$epic_field_id" \
    --text "$module"

  # Set Feature
  gh project item-edit \
    --id "$item_id" \
    --project-id "$project_id" \
    --field-id "$feature_field_id" \
    --text "$feature"

  # Set Role
  gh project item-edit \
    --id "$item_id" \
    --project-id "$project_id" \
    --field-id "$role_field_id" \
    --text "$role"

  # Set Estimate
  gh project item-edit \
    --id "$item_id" \
    --project-id "$project_id" \
    --field-id "$estimate_field_id" \
    --number "$hours"

  echo "✅ Item created: $module:$feature:$task:$role:$hours"
  echo
done

set +e
