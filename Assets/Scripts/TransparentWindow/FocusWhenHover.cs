using UnityEngine;
using UnityEngine.EventSystems;

namespace Demos
{
    public class FocusWhenHover : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler, IPointerClickHandler, IPointerDownHandler
    {
        private ShowToyShaders showToyShaders;

        private void Awake()
        {
            showToyShaders = GetComponent<ShowToyShaders>();
        }

        public void OnPointerClick(PointerEventData eventData)
        {
            SimpleDebugText.SetContent("OnClick");
            if (eventData.button == PointerEventData.InputButton.Right)
            {
                showToyShaders.SetShaderPath("Toy/ToyShader10");
            }
            if (eventData.button == PointerEventData.InputButton.Left)
            {
                showToyShaders.SetShaderPath("Toy/ToyShader11");
            }
            if (eventData.button == PointerEventData.InputButton.Middle)
            {
                showToyShaders.SetShaderPath("Toy/ToyShader12");
            }
        }

        public void OnPointerEnter(PointerEventData eventData)
        {
            SimpleDebugText.SetContent("Enter");
            showToyShaders.SetShaderPath("Toy/ToyShader11");
            TransparentWindow.instance.SetClickThrough(false);
        }

        public void OnPointerExit(PointerEventData eventData)
        {
            SimpleDebugText.SetContent("Exit");
            showToyShaders.SetShaderPath("Toy/ToyShader13");
            TransparentWindow.instance.SetClickThrough(true);
        }

        public void OnPointerDown(PointerEventData eventData)
        {
            //     SimpleDebugText.SetContent("On mouse Down");
            //     if (eventData.button == PointerEventData.InputButton.Right)
            //     {
            //         Log.Debug("Right");
            //         showToyShaders.SetShaderPath("Toy/ToyShader10");
            //     }
            //     if (eventData.button == PointerEventData.InputButton.Left)
            //     {
            //         Log.Debug("Left");
            //         showToyShaders.SetShaderPath("Toy/ToyShader11");
            //     }
            //     if (eventData.button == PointerEventData.InputButton.Middle)
            //     {
            //         Log.Debug("Middle");
            //         showToyShaders.SetShaderPath("Toy/ToyShader12");
            //     }
        }
    }
}
