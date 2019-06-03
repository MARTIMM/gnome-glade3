#include <stdio.h>
#include <stdlib.h>

typedef enum
{
  GDK_SETTING_ACTION_NEW,
  GDK_SETTING_ACTION_CHANGED,
  GDK_SETTING_ACTION_DELETED
} GdkSettingAction;

typedef enum
{
  GDK_WINDOW_STATE_WITHDRAWN        = 1 << 0,
  GDK_WINDOW_STATE_ICONIFIED        = 1 << 1,
  GDK_WINDOW_STATE_MAXIMIZED        = 1 << 2,
  GDK_WINDOW_STATE_STICKY           = 1 << 3,
  GDK_WINDOW_STATE_FULLSCREEN       = 1 << 4,
  GDK_WINDOW_STATE_ABOVE            = 1 << 5,
  GDK_WINDOW_STATE_BELOW            = 1 << 6,
  GDK_WINDOW_STATE_FOCUSED          = 1 << 7,
  GDK_WINDOW_STATE_TILED            = 1 << 8,
  GDK_WINDOW_STATE_TOP_TILED        = 1 << 9,
  GDK_WINDOW_STATE_TOP_RESIZABLE    = 1 << 10,
  GDK_WINDOW_STATE_RIGHT_TILED      = 1 << 11,
  GDK_WINDOW_STATE_RIGHT_RESIZABLE  = 1 << 12,
  GDK_WINDOW_STATE_BOTTOM_TILED     = 1 << 13,
  GDK_WINDOW_STATE_BOTTOM_RESIZABLE = 1 << 14,
  GDK_WINDOW_STATE_LEFT_TILED       = 1 << 15,
  GDK_WINDOW_STATE_LEFT_RESIZABLE   = 1 << 16
} GdkWindowState;

typedef enum
{
  GDK_NOTHING		= -1,
  GDK_DELETE		= 0,
  GDK_DESTROY		= 1,
  GDK_EXPOSE		= 2,
  GDK_MOTION_NOTIFY	= 3,
  GDK_BUTTON_PRESS	= 4,
  GDK_2BUTTON_PRESS	= 5,
  GDK_DOUBLE_BUTTON_PRESS = GDK_2BUTTON_PRESS,
  GDK_3BUTTON_PRESS	= 6,
  GDK_TRIPLE_BUTTON_PRESS = GDK_3BUTTON_PRESS,
  GDK_BUTTON_RELEASE	= 7,
  GDK_KEY_PRESS		= 8,
  GDK_KEY_RELEASE	= 9,
  GDK_ENTER_NOTIFY	= 10,
  GDK_LEAVE_NOTIFY	= 11,
  GDK_FOCUS_CHANGE	= 12,
  GDK_CONFIGURE		= 13,
  GDK_MAP		= 14,
  GDK_UNMAP		= 15,
  GDK_PROPERTY_NOTIFY	= 16,
  GDK_SELECTION_CLEAR	= 17,
  GDK_SELECTION_REQUEST = 18,
  GDK_SELECTION_NOTIFY	= 19,
  GDK_PROXIMITY_IN	= 20,
  GDK_PROXIMITY_OUT	= 21,
  GDK_DRAG_ENTER        = 22,
  GDK_DRAG_LEAVE        = 23,
  GDK_DRAG_MOTION       = 24,
  GDK_DRAG_STATUS       = 25,
  GDK_DROP_START        = 26,
  GDK_DROP_FINISHED     = 27,
  GDK_CLIENT_EVENT	= 28,
  GDK_VISIBILITY_NOTIFY = 29,
  GDK_SCROLL            = 31,
  GDK_WINDOW_STATE      = 32,
  GDK_SETTING           = 33,
  GDK_OWNER_CHANGE      = 34,
  GDK_GRAB_BROKEN       = 35,
  GDK_DAMAGE            = 36,
  GDK_TOUCH_BEGIN       = 37,
  GDK_TOUCH_UPDATE      = 38,
  GDK_TOUCH_END         = 39,
  GDK_TOUCH_CANCEL      = 40,
  GDK_TOUCHPAD_SWIPE    = 41,
  GDK_TOUCHPAD_PINCH    = 42,
  GDK_PAD_BUTTON_PRESS  = 43,
  GDK_PAD_BUTTON_RELEASE = 44,
  GDK_PAD_RING          = 45,
  GDK_PAD_STRIP         = 46,
  GDK_PAD_GROUP_MODE    = 47,
  GDK_EVENT_LAST        /* helper variable for decls */
} GdkEventType;

int main ( ) {
  printf( "enum size GdkSettingAction: %d\n", sizeof(GdkSettingAction));
  printf( "enum size GdkWindowState: %d\n", sizeof(GdkWindowState));
  printf( "enum size GdkEventType: %d\n", sizeof(GdkEventType));

  exit(0);
}
