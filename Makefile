CC = gcc
CFLAGS = -Wall -Wextra -Isrc/include
TARGET = template
SRCDIR = src
OBJDIR = obj
SOURCES = $(SRCDIR)/main.c $(SRCDIR)/help.c
OBJS = $(SOURCES:.c=.o)

.PHONY: all clean install uninstall

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)

install:
	install -Dm755 $(TARGET) $(DESTDIR)/usr/bin/$(TARGET)
	install -Dm644 $(TARGET).desktop $(DESTDIR)/usr/share/applications/$(TARGET).desktop
	install -Dm644 icons/$(TARGET)-app_16x16.png $(DESTDIR)/usr/share/icons/breeze/apps/16/$(TARGET)-app_16x16.png
	install -Dm644 icons/$(TARGET)-app_32x32.png $(DESTDIR)/usr/share/icons/breeze/apps/32/$(TARGET)-app_32x32.png
	install -Dm644 icons/$(TARGET)-app_48x48.png $(DESTDIR)/usr/share/icons/breeze/apps/48/$(TARGET)-app_48x48.png

uninstall:
	rm -f $(DESTDIR)/usr/bin/$(TARGET)
	rm -f $(DESTDIR)/usr/share/applications/$(TARGET).desktop
	rm -f $(DESTDIR)/usr/share/icons/breeze/apps/16/$(TARGET)-app_16x16.png
	rm -f $(DESTDIR)/usr/share/icons/breeze/apps/32/$(TARGET)-app_32x32.png
	rm -f $(DESTDIR)/usr/share/icons/breeze/apps/48/$(TARGET)-app_48x48.png
