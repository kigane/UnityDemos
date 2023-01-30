using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class AdditionalDemo : MonoBehaviour
{
    // 
    public Transform jumper, puncher, shaker, target;
    public MeshRenderer changer;

    private void Start()
    {
        DOVirtual.Float(0, 10f, 0.5f, (v) =>
        {
            Debug.Log(v);
        }).SetEase(Ease.InBounce);
    }

    public void Jump()
    {
        var pos = jumper.position;
        jumper.DOJump(
            endValue: pos,
            jumpPower: 2,
            numJumps: 2,
            duration: 1
        );
    }

    public void Shake()
    {
        float duration = 0.5f;
        float strength = 0.5f;

        shaker.DOShakePosition(duration, strength);
        shaker.DOShakeRotation(duration, strength);
        shaker.DOShakeScale(duration, strength);

        // DOTween.KillAll();
    }

    public void Punch()
    {
        float duration = 0.5f;
        puncher.DOPunchPosition(
            punch: Vector3.left * 2,
            duration: duration,
            vibrato: 0,
            elasticity: 0
        );

        target.DOShakePosition(
            duration: 0.5f,
            strength: 0.5f,
            vibrato: 10
        ).SetDelay(duration * 0.5f);
    }

    public void Change()
    {
        changer.material.DOColor(Random.ColorHSV(), 0.5f).OnComplete(Change);
    }
}
