using UnityEngine;
using TMPro;
using UnityEngine.InputSystem;

public class TMPController : MonoBehaviour
{
    [SerializeField] private TextMeshProUGUI tmpElement;
    private void Update() {
        if (Keyboard.current.tKey.isPressed)
        {
            OnButtonPressed();
        }
    }

    private void OnButtonPressed()
    {
        tmpElement.text = "高达屹立于大地之上";
        tmpElement.textStyle = TMP_Style.NormalStyle;
        tmpElement.fontStyle = FontStyles.Bold;
        tmpElement.color = Color.cyan;
        tmpElement.fontSize = 42f;
    }
}
