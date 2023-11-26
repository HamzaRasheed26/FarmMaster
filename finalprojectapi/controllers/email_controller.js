const Email=require('../models/email_model')
async function createEmail(req, res){
    try{ 
        const {Name,Subject,email,msg}=req.body
        const mail= await Email.create({Name,Subject,email,msg});
        res.status(201).json({status:true,mail});
    }
    catch(err){
        res.status(500).json({status:false,error: err.message});
    }
}

async function getAllemails(req, res) {
    try {
        const emails = await Email.find();
        const emailsDetails = emails.map(mail => ({
            id: mail.id,
            Name: mail.Name,
            Subject: mail.Subject,
            email: mail.email,
            msg: mail.msg,
        }));
        return res.status(200).json({ status: true, emails: emailsDetails });
    } catch (err) {
        res.status(500).json({ status: false, error: err.message });
    }
}
async function deleteEmail (req, res) {

    try {
        const {id} = req.params;
        await Email.findByIdAndDelete(id);
        res.sendStatus (204); 
    } catch (err) {
        res.status(500).json({status:false, error: err.message });
    }
}


module.exports={
    createEmail,
    getAllemails,
    deleteEmail,
};