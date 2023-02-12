using UnityEngine;

namespace Demos
{
    public class ShapeFuncShader : ShaderToyBase
    {
        [SerializeField, Range(0, 1f)] float _radius = 0.5f;
        int _radiusId = Shader.PropertyToID("_Radius");

        protected override void SetMatProperties()
        {
            material.SetFloat(_radiusId, _radius);
        }
    }
}
