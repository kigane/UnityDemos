using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using System.Threading.Tasks;

public class SeqDemo : MonoBehaviour
{
    public Transform[] cubes;

    void Start()
    {
        // Sequence 
        var sequence = DOTween.Sequence();
        foreach (var item in cubes)
        {
            sequence.Append(item.DOMoveX(item.position.x + 5, Random.Range(1f, 2f)));
            // SetSpeedBased(true)后，duration就变成表示speed了。可以实现让所有物体以同一速度移动。
            // sequence.Append(item.DOMoveX(item.position.x + 5, Random.Range(1f, 2f)).SetSpeedBased(true));
        }

        sequence.OnComplete(() =>
        {
            foreach (var item in cubes)
            {
                item.DOScale(Vector3.zero, Random.Range(1f, 2f));
            }
        });
    }

    // async void AsyncBody()
    // {
    //     foreach (var item in cubes)
    //     {
    //         await item.DOMoveX(item.position.x + 5, Random.Range(1f, 2f)).AsyncWaitForCompletion();
    //     }
    // }
}
