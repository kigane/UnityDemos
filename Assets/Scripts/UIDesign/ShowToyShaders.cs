using UnityEngine;

namespace Demos
{
    public class ShowToyShaders : CustomImageBase
    {
        [SerializeField] private string shaderPath = "Toy/ToyShader13";

        [Header("Shader Variables")]
        [SerializeField] private Texture2D _mainTex;
        [SerializeField, ColorUsage(true, false)] private Color _Color;
        [SerializeField, Range(0, 1f)] float _radius = 0.5f;
        [SerializeField, Range(0, 1f)] float _magnitude = 1f;
        [SerializeField, Range(0, 20)] int _factora = 1;
        [SerializeField, Range(0, 20)] int _factorb = 1;

        private int _colorId = Shader.PropertyToID("_Color");
        int _radiusId = Shader.PropertyToID("_Radius");
        int _magnitudeId = Shader.PropertyToID("_Magnitude");
        int _factoraId = Shader.PropertyToID("_Factora");
        int _factorbId = Shader.PropertyToID("_Factorb");

        protected override void UpdateMaterial(Material baseMaterial)
        {
            if (material == null)
            {
                material = new Material(Shader.Find(shaderPath));
                material.hideFlags = HideFlags.HideAndDontSave;
            }
            material.mainTexture = _mainTex;
            material.SetColor(_colorId, _Color);
            material.SetFloat(_radiusId, _radius);
            material.SetFloat(_magnitudeId, _magnitude);
            material.SetFloat(_factoraId, _factora);
            material.SetFloat(_factorbId, _factorb);
        }

        public void SetShaderPath(string shaderPath)
        {
            this.shaderPath = shaderPath;
            material.shader = Shader.Find(shaderPath);
            // material.SetFloat(_magnitudeId, 0.8f); // 可以在设置的时候传参数
        }
    }
}
