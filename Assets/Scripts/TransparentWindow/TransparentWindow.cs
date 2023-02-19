using System;
using System.Runtime.InteropServices;
using UnityEngine;

namespace Demos
{
    public class TransparentWindow : MonoBehaviour
    {
        public static TransparentWindow instance;

        [DllImport("user32.dll")]
        public static extern int MessageBox(IntPtr hwnd, string text, string caption, uint type);

        // 设置窗口风格。实现鼠标点击穿透。
        public static IntPtr SetWindowLongPtr(HandleRef hWnd, int nIndex, IntPtr dwNewLong)
        {
            if (IntPtr.Size == 8)
                return SetWindowLongPtr64(hWnd, nIndex, dwNewLong);
            else
                return new IntPtr(SetWindowLong32(hWnd, nIndex, dwNewLong.ToInt32()));
        }
        public static IntPtr SetWindowLongPtr(HandleRef hWnd, int nIndex, uint dwNewLong)
        {
            return SetWindowLongPtr(hWnd, nIndex, new IntPtr(dwNewLong));
        }
        [DllImport("user32.dll", EntryPoint = "SetWindowLong")]
        private static extern int SetWindowLong32(HandleRef hWnd, int nIndex, int dwNewLong);
        [DllImport("user32.dll", EntryPoint = "SetWindowLongPtr")]
        private static extern IntPtr SetWindowLongPtr64(HandleRef hWnd, int nIndex, IntPtr dwNewLong);

        // 设置窗口位置
        [DllImport("user32.dll", SetLastError = true)]
        public static extern int SetWindowPos(IntPtr hwnd, IntPtr hwndInsertAfter, int x, int y, int cx, int cy, int uFlags);

        // 获取当前窗口句柄
        [DllImport("user32.dll")]
        public static extern IntPtr GetActiveWindow();

        private struct MARGINS
        {
            public int cxLeftWidth;
            public int cxRightWidth;
            public int cyTopWidth;
            public int cyBottomWidth;
        }

        // 实现窗口透明效果。
        [DllImport("Dwmapi.dll")]
        private static extern uint DwmExtendFrameIntoClientArea(IntPtr hWnd, ref MARGINS mARGINS);

        // 表示修改窗口的额外风格。
        const int GWL_EXSTYLE = -20;
        // 使用alpha混合
        const uint WS_EX_LAYERED = 0x00080000;
        // 可以去掉任务栏图标
        const uint WS_EX_TOOLWINDOW = 0x00000080;
        // 点击会穿透。
        const uint WS_EX_TRANSPARENT = 0x00000020;

        const int SWP_SHOWWINDOW = 0x0040;

        // 窗口顺序。跟在该窗口后即为保持最前。
        static readonly IntPtr HWND_TOPMOST = new IntPtr(-1);

        // 当前窗口句柄以及最新API需要的封装
        private IntPtr hwnd;
        private HandleRef hWnd;

        void Awake()
        {
            instance = this;

            // MessageBox(new IntPtr(0), "Hello World", "This is caption", 0);

            // 获取屏幕宽高
            int fWidth = Screen.width;
            int fHeight = Screen.height;
            SimpleDebugText.SetContent($"屏幕宽高 {fWidth} {fHeight}");

            // 获取窗口句柄
            IntPtr hwnd = GetActiveWindow();
            hWnd = new HandleRef(this, hwnd);

            // 设置窗口透明，风格，位置
#if !UNITY_EDITOR
        MARGINS margins = new MARGINS { cxLeftWidth = -1, cxRightWidth = -1, cyTopWidth =-1, cyBottomWidth = -1 };
        DwmExtendFrameIntoClientArea(hwnd, ref margins);
        SetWindowLongPtr(hWnd, GWL_EXSTYLE, WS_EX_LAYERED | WS_EX_TRANSPARENT);
        SetWindowPos(hwnd, HWND_TOPMOST, 0, 0, fWidth, fHeight, SWP_SHOWWINDOW);
#endif
            // Debug.Log(Application.runInBackground);
        }

        private void Update()
        {
            // 如果当前鼠标位置在有Collider的物体上，则不穿透，鼠标点击会作用于UnityApp。
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            bool isCollider = Physics.Raycast(ray, out RaycastHit hit);
            if (hit.collider && hit.collider.gameObject.name == "Cube")
            {
#if UNITY_EDITOR // 编辑器环境
                UnityEditor.EditorApplication.isPlaying = false;
#else //打包出来的环境下
                Application.Quit();
#endif
            }
            // SetClickThrough(!isCollider);
        }

        public void SetClickThrough(bool clickThrough)
        {
#if !UNITY_EDITOR
            if (clickThrough)
            {
                SetWindowLongPtr(hWnd, GWL_EXSTYLE, WS_EX_LAYERED | WS_EX_TRANSPARENT);
            }
            else
            { 
                SetWindowLongPtr(hWnd, GWL_EXSTYLE, WS_EX_LAYERED);
            }
#endif
        }
    }

}
