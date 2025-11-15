#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Using: $0 <new_name>"
    echo "Example: $0 myapp"
    exit 1
fi

OLD_NAME="template"
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
find . -type f \( -name "*.md" -o -name "*.desktop" -o -name "Makefile" -o -name "PKGBUILD" -o -name "*.c" -o -name "*.h" \) -not -path "./.git/*" | while read -r file; do
    safe_replace "$file"
done

# Переименовываем файлы
echo "Renaming..."

[ -f "template.desktop" ] && mv "template.desktop" "${NEW_NAME}.desktop"
[ -f "icons/template.xpm" ] && mv "icons/template.xpm" "icons/${NEW_NAME}.xpm"

# Обновляем название приложения в .desktop файле
if [ -f "${NEW_NAME}.desktop" ]; then
    echo "Update a .desktop file..."
    sed -i "
        s/Name=TemplateApp/Name=$APP_ESCAPED/g
        s/Name\[en_US\]=TemplateApp/Name[en_US]=$APP_ESCAPED/g
        s/Comment=Lorem Ipsum/Comment=$APP_ESCAPED Application/g
        s/Comment\[en_US\]=Lorem Ipsum/Comment[en_US]=$APP_ESCAPED Application/g
    " "${NEW_NAME}.desktop"
fi

echo "Complete!"
echo "Check: grep -r 'Name=' ${NEW_NAME}.desktop"
echo "Check: grep -r '$NEW_NAME' ."

rm -f ./rename_template.sh
