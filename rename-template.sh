#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Using: $0 <new_name>"
    echo "Example: $0 myapp"
    exit 1
fi

OLD_NAME="test"
NEW_NAME="$1"

# Автоматическое создание названия приложения (первая буква заглавная)
APP_NAME="${NEW_NAME^}App"

echo "Change a '$OLD_NAME' to '$NEW_NAME' in every file..."
echo "App name: '$APP_NAME'"

# Экранируем специальные символы для sed
OLD_ESCAPED=$(printf '%s\n' "$OLD_NAME" | sed 's/[[\.*^$()+?{|]/\\&/g')
NEW_ESCAPED=$(printf '%s\n' "$NEW_NAME" | sed 's/[\/&]/\\&/g')
APP_ESCAPED=$(printf '%s\n' "$APP_NAME" | sed 's/[\/&]/\\&/g')

# Функция для безопасной замены
safe_replace() {
    local file="$1"
    if [ -f "$file" ] && [ -r "$file" ] && [ -w "$file" ]; then
        if grep -q "$OLD_NAME" "$file" 2>/dev/null; then
            echo "Work with: $file"
            sed -i "s/$OLD_ESCAPED/$NEW_ESCAPED/g" "$file"
        fi
    fi
}

# Обрабатываем все текстовые файлы
find . -type f \( -name "*.md" -o -name "*.desktop" -o -name "Makefile" -o -name "PKGBUILD" -o -name "*.c" -o -name "*.h" -o -name "clean.sh" -o -name "rename-test.sh" \) ! -path "./.git/*" | while read -r file; do
    safe_replace "$file"
done

# Переименовываем файлы
echo "Renaming..."

[ -f "test.desktop" ] && mv "test.desktop" "${NEW_NAME}.desktop"

# Rename all icon files (both PNG and XCF)
for file in icons/test*; do
    if [ -f "$file" ]; then
        new_file=$(echo "$file" | sed "s/test/$NEW_NAME/g")
        mv "$file" "$new_file"
        echo "Renamed: $file -> $new_file"
    fi
done

# Обновляем название приложения в .desktop файле
if [ -f "${NEW_NAME}.desktop" ]; then
    echo "Update a .desktop file..."
    sed -i "
        s/Name=TemplateApp/Name=$APP_ESCAPED/g
        s/Name\[en_US\]=TemplateApp/Name[en_US]=$APP_ESCAPED/g
        s/Comment=Lorem Ipsum/Comment=$APP_ESCAPED Application/g
        s/Comment\[en_US\]=Lorem Ipsum/Comment[en_US]=$APP_ESCAPED Application/g
        s/Exec=test/Exec=$NEW_ESCAPED/g
        s/Icon=test-app_48x48/Icon=$NEW_ESCAPED-app_48x48/g
    " "${NEW_NAME}.desktop"
fi

# Additional replacements for specific patterns
if [ -f "Makefile" ]; then
    sed -i "s/TARGET = test/TARGET = $NEW_ESCAPED/g" "Makefile"
    # Also update icon references in Makefile
    sed -i "s/icons\/test-app_/icons\/$NEW_ESCAPED-app_/g" "Makefile"
fi

if [ -f "PKGBUILD" ]; then
    sed -i "s/pkgname=test/pkgname=$NEW_ESCAPED/g" "PKGBUILD"
fi

echo "Complete!"
echo "Check: grep -r 'Name=' ${NEW_NAME}.desktop"
echo "Check: grep -r '$NEW_NAME' ."

# Create a backup of the original script if you want to keep it
# cp ./rename-test.sh ./rename-test-backup.sh
