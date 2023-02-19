using UnityEngine;
using UnityEngine.UI;

namespace Demos
{
    public class SimpleDebugText : MonoBehaviour
    {
        public Text text;
        private static string content = "Hello";

        // Update is called once per frame
        void Update()
        {
            text.text = content;
        }

        public static void SetContent(string s)
        {
            content = s;
        }
    }
}
