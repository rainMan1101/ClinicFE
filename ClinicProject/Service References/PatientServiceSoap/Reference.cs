﻿//------------------------------------------------------------------------------
// <auto-generated>
//     Этот код создан программой.
//     Исполняемая версия:4.0.30319.42000
//
//     Изменения в этом файле могут привести к неправильной работе и будут потеряны в случае
//     повторной генерации кода.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ClinicProject.PatientServiceSoap {
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ServiceModel.ServiceContractAttribute(Namespace="http://tempuri.org/NumberService", ConfigurationName="PatientServiceSoap.PatientServiceSoap")]
    public interface PatientServiceSoap {
        
        // CODEGEN: Контракт генерации сообщений с именем ppatient из пространства имен http://tempuri.org/NumberService не отмечен как обнуляемый
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/NumberService/generateTalon", ReplyAction="*")]
        ClinicProject.PatientServiceSoap.generateTalonResponse generateTalon(ClinicProject.PatientServiceSoap.generateTalonRequest request);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/NumberService/generateTalon", ReplyAction="*")]
        System.Threading.Tasks.Task<ClinicProject.PatientServiceSoap.generateTalonResponse> generateTalonAsync(ClinicProject.PatientServiceSoap.generateTalonRequest request);
        
        // CODEGEN: Контракт генерации сообщений с именем ppatient из пространства имен http://tempuri.org/NumberService не отмечен как обнуляемый
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/NumberService/getTalon", ReplyAction="*")]
        ClinicProject.PatientServiceSoap.getTalonResponse getTalon(ClinicProject.PatientServiceSoap.getTalonRequest request);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/NumberService/getTalon", ReplyAction="*")]
        System.Threading.Tasks.Task<ClinicProject.PatientServiceSoap.getTalonResponse> getTalonAsync(ClinicProject.PatientServiceSoap.getTalonRequest request);
        
        // CODEGEN: Контракт генерации сообщений с именем ppatient из пространства имен http://tempuri.org/NumberService не отмечен как обнуляемый
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/NumberService/getMedCard", ReplyAction="*")]
        ClinicProject.PatientServiceSoap.getMedCardResponse getMedCard(ClinicProject.PatientServiceSoap.getMedCardRequest request);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/NumberService/getMedCard", ReplyAction="*")]
        System.Threading.Tasks.Task<ClinicProject.PatientServiceSoap.getMedCardResponse> getMedCardAsync(ClinicProject.PatientServiceSoap.getMedCardRequest request);
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class generateTalonRequest {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="generateTalon", Namespace="http://tempuri.org/NumberService", Order=0)]
        public ClinicProject.PatientServiceSoap.generateTalonRequestBody Body;
        
        public generateTalonRequest() {
        }
        
        public generateTalonRequest(ClinicProject.PatientServiceSoap.generateTalonRequestBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute(Namespace="http://tempuri.org/NumberService")]
    public partial class generateTalonRequestBody {
        
        [System.Runtime.Serialization.DataMemberAttribute(Order=0)]
        public System.DateTime pdate;
        
        [System.Runtime.Serialization.DataMemberAttribute(Order=1)]
        public int pdoctor;
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=2)]
        public string ppatient;
        
        public generateTalonRequestBody() {
        }
        
        public generateTalonRequestBody(System.DateTime pdate, int pdoctor, string ppatient) {
            this.pdate = pdate;
            this.pdoctor = pdoctor;
            this.ppatient = ppatient;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class generateTalonResponse {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="generateTalonResponse", Namespace="http://tempuri.org/NumberService", Order=0)]
        public ClinicProject.PatientServiceSoap.generateTalonResponseBody Body;
        
        public generateTalonResponse() {
        }
        
        public generateTalonResponse(ClinicProject.PatientServiceSoap.generateTalonResponseBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute()]
    public partial class generateTalonResponseBody {
        
        public generateTalonResponseBody() {
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class getTalonRequest {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="getTalon", Namespace="http://tempuri.org/NumberService", Order=0)]
        public ClinicProject.PatientServiceSoap.getTalonRequestBody Body;
        
        public getTalonRequest() {
        }
        
        public getTalonRequest(ClinicProject.PatientServiceSoap.getTalonRequestBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute(Namespace="http://tempuri.org/NumberService")]
    public partial class getTalonRequestBody {
        
        [System.Runtime.Serialization.DataMemberAttribute(Order=0)]
        public System.DateTime pdate;
        
        [System.Runtime.Serialization.DataMemberAttribute(Order=1)]
        public int pdoctor;
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=2)]
        public string ppatient;
        
        public getTalonRequestBody() {
        }
        
        public getTalonRequestBody(System.DateTime pdate, int pdoctor, string ppatient) {
            this.pdate = pdate;
            this.pdoctor = pdoctor;
            this.ppatient = ppatient;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class getTalonResponse {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="getTalonResponse", Namespace="http://tempuri.org/NumberService", Order=0)]
        public ClinicProject.PatientServiceSoap.getTalonResponseBody Body;
        
        public getTalonResponse() {
        }
        
        public getTalonResponse(ClinicProject.PatientServiceSoap.getTalonResponseBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute(Namespace="http://tempuri.org/NumberService")]
    public partial class getTalonResponseBody {
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=0)]
        public byte[] getTalonResult;
        
        public getTalonResponseBody() {
        }
        
        public getTalonResponseBody(byte[] getTalonResult) {
            this.getTalonResult = getTalonResult;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class getMedCardRequest {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="getMedCard", Namespace="http://tempuri.org/NumberService", Order=0)]
        public ClinicProject.PatientServiceSoap.getMedCardRequestBody Body;
        
        public getMedCardRequest() {
        }
        
        public getMedCardRequest(ClinicProject.PatientServiceSoap.getMedCardRequestBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute(Namespace="http://tempuri.org/NumberService")]
    public partial class getMedCardRequestBody {
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=0)]
        public string ppatient;
        
        public getMedCardRequestBody() {
        }
        
        public getMedCardRequestBody(string ppatient) {
            this.ppatient = ppatient;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class getMedCardResponse {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="getMedCardResponse", Namespace="http://tempuri.org/NumberService", Order=0)]
        public ClinicProject.PatientServiceSoap.getMedCardResponseBody Body;
        
        public getMedCardResponse() {
        }
        
        public getMedCardResponse(ClinicProject.PatientServiceSoap.getMedCardResponseBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute(Namespace="http://tempuri.org/NumberService")]
    public partial class getMedCardResponseBody {
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=0)]
        public byte[] getMedCardResult;
        
        public getMedCardResponseBody() {
        }
        
        public getMedCardResponseBody(byte[] getMedCardResult) {
            this.getMedCardResult = getMedCardResult;
        }
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public interface PatientServiceSoapChannel : ClinicProject.PatientServiceSoap.PatientServiceSoap, System.ServiceModel.IClientChannel {
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public partial class PatientServiceSoapClient : System.ServiceModel.ClientBase<ClinicProject.PatientServiceSoap.PatientServiceSoap>, ClinicProject.PatientServiceSoap.PatientServiceSoap {
        
        public PatientServiceSoapClient() {
        }
        
        public PatientServiceSoapClient(string endpointConfigurationName) : 
                base(endpointConfigurationName) {
        }
        
        public PatientServiceSoapClient(string endpointConfigurationName, string remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public PatientServiceSoapClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public PatientServiceSoapClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(binding, remoteAddress) {
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        ClinicProject.PatientServiceSoap.generateTalonResponse ClinicProject.PatientServiceSoap.PatientServiceSoap.generateTalon(ClinicProject.PatientServiceSoap.generateTalonRequest request) {
            return base.Channel.generateTalon(request);
        }
        
        public void generateTalon(System.DateTime pdate, int pdoctor, string ppatient) {
            ClinicProject.PatientServiceSoap.generateTalonRequest inValue = new ClinicProject.PatientServiceSoap.generateTalonRequest();
            inValue.Body = new ClinicProject.PatientServiceSoap.generateTalonRequestBody();
            inValue.Body.pdate = pdate;
            inValue.Body.pdoctor = pdoctor;
            inValue.Body.ppatient = ppatient;
            ClinicProject.PatientServiceSoap.generateTalonResponse retVal = ((ClinicProject.PatientServiceSoap.PatientServiceSoap)(this)).generateTalon(inValue);
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        System.Threading.Tasks.Task<ClinicProject.PatientServiceSoap.generateTalonResponse> ClinicProject.PatientServiceSoap.PatientServiceSoap.generateTalonAsync(ClinicProject.PatientServiceSoap.generateTalonRequest request) {
            return base.Channel.generateTalonAsync(request);
        }
        
        public System.Threading.Tasks.Task<ClinicProject.PatientServiceSoap.generateTalonResponse> generateTalonAsync(System.DateTime pdate, int pdoctor, string ppatient) {
            ClinicProject.PatientServiceSoap.generateTalonRequest inValue = new ClinicProject.PatientServiceSoap.generateTalonRequest();
            inValue.Body = new ClinicProject.PatientServiceSoap.generateTalonRequestBody();
            inValue.Body.pdate = pdate;
            inValue.Body.pdoctor = pdoctor;
            inValue.Body.ppatient = ppatient;
            return ((ClinicProject.PatientServiceSoap.PatientServiceSoap)(this)).generateTalonAsync(inValue);
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        ClinicProject.PatientServiceSoap.getTalonResponse ClinicProject.PatientServiceSoap.PatientServiceSoap.getTalon(ClinicProject.PatientServiceSoap.getTalonRequest request) {
            return base.Channel.getTalon(request);
        }
        
        public byte[] getTalon(System.DateTime pdate, int pdoctor, string ppatient) {
            ClinicProject.PatientServiceSoap.getTalonRequest inValue = new ClinicProject.PatientServiceSoap.getTalonRequest();
            inValue.Body = new ClinicProject.PatientServiceSoap.getTalonRequestBody();
            inValue.Body.pdate = pdate;
            inValue.Body.pdoctor = pdoctor;
            inValue.Body.ppatient = ppatient;
            ClinicProject.PatientServiceSoap.getTalonResponse retVal = ((ClinicProject.PatientServiceSoap.PatientServiceSoap)(this)).getTalon(inValue);
            return retVal.Body.getTalonResult;
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        System.Threading.Tasks.Task<ClinicProject.PatientServiceSoap.getTalonResponse> ClinicProject.PatientServiceSoap.PatientServiceSoap.getTalonAsync(ClinicProject.PatientServiceSoap.getTalonRequest request) {
            return base.Channel.getTalonAsync(request);
        }
        
        public System.Threading.Tasks.Task<ClinicProject.PatientServiceSoap.getTalonResponse> getTalonAsync(System.DateTime pdate, int pdoctor, string ppatient) {
            ClinicProject.PatientServiceSoap.getTalonRequest inValue = new ClinicProject.PatientServiceSoap.getTalonRequest();
            inValue.Body = new ClinicProject.PatientServiceSoap.getTalonRequestBody();
            inValue.Body.pdate = pdate;
            inValue.Body.pdoctor = pdoctor;
            inValue.Body.ppatient = ppatient;
            return ((ClinicProject.PatientServiceSoap.PatientServiceSoap)(this)).getTalonAsync(inValue);
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        ClinicProject.PatientServiceSoap.getMedCardResponse ClinicProject.PatientServiceSoap.PatientServiceSoap.getMedCard(ClinicProject.PatientServiceSoap.getMedCardRequest request) {
            return base.Channel.getMedCard(request);
        }
        
        public byte[] getMedCard(string ppatient) {
            ClinicProject.PatientServiceSoap.getMedCardRequest inValue = new ClinicProject.PatientServiceSoap.getMedCardRequest();
            inValue.Body = new ClinicProject.PatientServiceSoap.getMedCardRequestBody();
            inValue.Body.ppatient = ppatient;
            ClinicProject.PatientServiceSoap.getMedCardResponse retVal = ((ClinicProject.PatientServiceSoap.PatientServiceSoap)(this)).getMedCard(inValue);
            return retVal.Body.getMedCardResult;
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        System.Threading.Tasks.Task<ClinicProject.PatientServiceSoap.getMedCardResponse> ClinicProject.PatientServiceSoap.PatientServiceSoap.getMedCardAsync(ClinicProject.PatientServiceSoap.getMedCardRequest request) {
            return base.Channel.getMedCardAsync(request);
        }
        
        public System.Threading.Tasks.Task<ClinicProject.PatientServiceSoap.getMedCardResponse> getMedCardAsync(string ppatient) {
            ClinicProject.PatientServiceSoap.getMedCardRequest inValue = new ClinicProject.PatientServiceSoap.getMedCardRequest();
            inValue.Body = new ClinicProject.PatientServiceSoap.getMedCardRequestBody();
            inValue.Body.ppatient = ppatient;
            return ((ClinicProject.PatientServiceSoap.PatientServiceSoap)(this)).getMedCardAsync(inValue);
        }
    }
}