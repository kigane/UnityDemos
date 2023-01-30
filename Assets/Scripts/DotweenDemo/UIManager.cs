using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class UIManager : MonoBehaviour
{
    public float fadeTime = 1f;
    public CanvasGroup canvasGroup;
    public RectTransform rectTransform;

    public void PanelFadeIn()
    {
        canvasGroup.alpha = 0;
        rectTransform.transform.localPosition = new Vector3(0, -1000f, 0);
        rectTransform.DOAnchorPos(new Vector2(0, 0), fadeTime, false).SetEase(Ease.OutElastic);
        canvasGroup.DOFade(1, fadeTime);
    }

    public void PanelFadeOut()
    {
        canvasGroup.alpha = 1;
        rectTransform.transform.localPosition = new Vector3(0, 0, 0);
        rectTransform.DOAnchorPos(new Vector2(0, -1000), fadeTime, false).SetEase(Ease.OutElastic);
        canvasGroup.DOFade(0, fadeTime);
    }
}
