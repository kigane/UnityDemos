using UnityEngine;

namespace Demos
{
    public class DialogBoxShake : CustomImageBase
    {
        [SerializeField] float _shakeSpeed = 1;
        [SerializeField] float _shakeAmount = 1;
        [SerializeField] float _OffsetH = 1;
        [SerializeField] float _OffsetV = 1;

        private int _shakeSpeedId = Shader.PropertyToID("_ShakeSpeed");
        private int _shakeAmountId = Shader.PropertyToID("_ShakeAmount");
        private int _OffsetHId = Shader.PropertyToID("_OffsetH");
        private int _OffsetVId = Shader.PropertyToID("_OffsetV");

        protected override void UpdateMaterial(Material baseMaterial)
        {
            if (material == null)
            {
                material = new Material(Shader.Find("UI/DialogBoxVertexShake"));
                material.hideFlags = HideFlags.HideAndDontSave;
            }

            material.SetFloat(_shakeSpeedId, _shakeSpeed);
            material.SetFloat(_shakeAmountId, _shakeAmount);
            material.SetFloat(_OffsetHId, _OffsetH);
            material.SetFloat(_OffsetVId, _OffsetV);
        }
    }
}
