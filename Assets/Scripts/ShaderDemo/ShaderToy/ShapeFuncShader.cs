using UnityEngine;

namespace Demos
{
    public class ShapeFuncShader : ShaderToyBase
    {
        [SerializeField, Range(0, 1f)] float _radius = 0.5f;
        [SerializeField, Range(0, 1f)] float _magnitude = 1f;
        [SerializeField, Range(0, 20)] int _factora = 1;
        [SerializeField, Range(0, 20)] int _factorb = 1;
        int _radiusId = Shader.PropertyToID("_Radius");
        int _magnitudeId = Shader.PropertyToID("_Magnitude");
        int _factoraId = Shader.PropertyToID("_Factora");
        int _factorbId = Shader.PropertyToID("_Factorb");

        protected override void SetMatProperties()
        {
            material.SetFloat(_radiusId, _radius);
            material.SetFloat(_magnitudeId, _magnitude);
            material.SetFloat(_factoraId, _factora);
            material.SetFloat(_factorbId, _factorb);
        }
    }
}
