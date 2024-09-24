import { findUserById } from "./users.services.js";

async function getUserById(req, res) {
    try {
        const user = await findUserById(req.params.id)
        if (!user) {
            res.status(404).send('User not found')
            return
        }
        res.status(200).send(user)
    }
    catch (err) {
        console.error(err)
    }
}

export {
    getUserById
};
